import json
import sqlite3
import numpy as np
import onnxruntime as ort
import os
import re
from transformers import BertTokenizer

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)

JSON_PATH = os.path.join(PROJECT_ROOT, "assets", "exercises", "exercises.json")
DB_PATH = os.path.join(PROJECT_ROOT, "assets", "exercises.db")
ONNX_MODEL_PATH = os.path.join(PROJECT_ROOT, "assets", "models", "model_quantized.onnx")
VOCAB_PATH = os.path.join(PROJECT_ROOT, "assets", "models", "vocab.txt")

def read_dart_table_constants(filepath, class_name):
    constants = {}
    if not os.path.exists(filepath):
        return constants
    with open(filepath, 'r') as f:
        content = f.read()
    
    matches = re.findall(r"static const\s+(\w+)\s*=\s*['\"]([^'\"]+)['\"];", content)
    for var_name, value in matches:
        constants[f"{class_name}.{var_name}"] = value
    return constants

def read_dart_schema_query(filepath):
    if not os.path.exists(filepath):
        return ""
    with open(filepath, 'r') as f:
        content = f.read()
    
    match = re.search(r"'''(.*?)'''", content, re.DOTALL)
    if match:
        return match.group(1).strip()
    return ""

def get_dart_schema_info():
    ex_table_path = os.path.join(PROJECT_ROOT, "lib", "core", "database", "tables", "exercise_table.dart")
    tags_table_path = os.path.join(PROJECT_ROOT, "lib", "core", "database", "tables", "tags_table.dart")
    
    constants = {}
    constants.update(read_dart_table_constants(ex_table_path, "ExerciseTable"))
    constants.update(read_dart_table_constants(tags_table_path, "TagsTable"))
    
    ex_schema_path = os.path.join(PROJECT_ROOT, "lib", "core", "database", "schema", "exercise_schema.dart")
    tags_schema_path = os.path.join(PROJECT_ROOT, "lib", "core", "database", "schema", "tags_schema.dart")
    
    ex_query = read_dart_schema_query(ex_schema_path)
    tags_query = read_dart_schema_query(tags_schema_path)
    
    for key, val in constants.items():
        ex_query = ex_query.replace(f"${{{key}}}", val)
        tags_query = tags_query.replace(f"${{{key}}}", val)
        
    return ex_query, tags_query, constants

def parse_list(string_val):
    if not string_val:
        return []
    return [s.strip() for s in string_val.split(';')]

def camel_case(s):
    if not s: return ''
    parts = s.split('_')
    return parts[0] + ''.join(word.title() for word in parts[1:])

def generate_embedding(text, tokenizer, session):
    if not text:
        return None
    inputs = tokenizer(text, max_length=128, padding='max_length', truncation=True, return_tensors='np')
    ort_inputs = {
        'input_ids': inputs['input_ids'].astype(np.int64),
        'attention_mask': inputs['attention_mask'].astype(np.int64),
        'token_type_ids': inputs['token_type_ids'].astype(np.int64)
    }
    outputs = session.run(None, ort_inputs)
    return outputs[0][0, 0, :].astype(np.float32)

def main():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    tokenizer = BertTokenizer(vocab_file=VOCAB_PATH, do_lower_case=True)
    session = ort.InferenceSession(ONNX_MODEL_PATH)

    ex_query, tags_query, dart_vars = get_dart_schema_info()

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute(ex_query)
    cursor.execute(tags_query)
    conn.commit()

    with open(JSON_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    exercises = data.get('exercises', [])

    unique_goals = set()
    unique_injuries = set()

    for ex in exercises:
        goal_str = ex.get('goal_tags', '')
        if goal_str:
            unique_goals.update(parse_list(goal_str))
        
        contra_str = ex.get('contraindications', '')
        if contra_str:
            unique_injuries.update(parse_list(contra_str))

        body_regions = [camel_case(r) for r in parse_list(ex.get('body_region', ''))]
        raw_equipments = parse_list(ex.get('equipments', ''))
        equipments = []
        for e in raw_equipments:
            camel_e = camel_case(e)
            if camel_e == 'dumbbell':
                camel_e = 'dumbbells'
            equipments.append(camel_e)

        cols = [
            dart_vars['ExerciseTable.exerciseId'], dart_vars['ExerciseTable.name'],
            dart_vars['ExerciseTable.type'], dart_vars['ExerciseTable.primaryMuscles'],
            dart_vars['ExerciseTable.secondaryMuscles'], dart_vars['ExerciseTable.bodyRegions'],
            dart_vars['ExerciseTable.movementPattern'], dart_vars['ExerciseTable.difficulty'],
            dart_vars['ExerciseTable.intensity'], dart_vars['ExerciseTable.goalTags'],
            dart_vars['ExerciseTable.estimatedTime'], dart_vars['ExerciseTable.overview'],
            dart_vars['ExerciseTable.benefits'], dart_vars['ExerciseTable.contraindications'],
            dart_vars['ExerciseTable.instructions'], dart_vars['ExerciseTable.isLottie'],
            dart_vars['ExerciseTable.equipments'], dart_vars['ExerciseTable.animationLink']
        ]
        
        col_names = ", ".join(cols)
        placeholders = ", ".join(["?"] * len(cols))
        insert_query = f"INSERT INTO {dart_vars['ExerciseTable.tableName']} ({col_names}) VALUES ({placeholders})"

        cursor.execute(insert_query, (
            ex['exercise_id'], ex['name'], camel_case(ex['type']),
            json.dumps(parse_list(ex.get('primary_muscles', ''))),
            json.dumps(parse_list(ex.get('secondary_muscles', ''))),
            json.dumps(body_regions), ex.get('movement_pattern', ''),
            camel_case(ex.get('difficulty', 'beginner')),
            camel_case(ex.get('intensity', 'moderate')),
            json.dumps(parse_list(goal_str)), 30, 
            ex.get('overview', ''), ex.get('benefits', ''),
            json.dumps(parse_list(contra_str)), ex.get('instructions', ''),
            1 if ex.get('is_lottie', False) else 0,
            json.dumps(equipments), ex.get('animation_link', '')
        ))

    conn.commit()

    def process_tags(tag_set, tag_type_name):
        count = 0
        emb_dim = 0
        tag_col = dart_vars['TagsTable.tagName']
        type_col = dart_vars['TagsTable.tagType']
        emb_col = dart_vars['TagsTable.embedding']
        table_name = dart_vars['TagsTable.tableName']
        
        insert_q = f"INSERT INTO {table_name} ({tag_col}, {type_col}, {emb_col}) VALUES (?, ?, ?)"
        
        for tag in tag_set:
            if not tag: continue
            
            embedding_array = generate_embedding(tag, tokenizer, session)
            emb_dim = len(embedding_array)
            cursor.execute(insert_q, (tag, tag_type_name, embedding_array.tobytes()))
            count += 1
        return count, emb_dim

    goal_count, dim1 = process_tags(unique_goals, 'goal')
    injury_count, dim2 = process_tags(unique_injuries, 'injury')
    
    conn.commit()
    conn.close()
    
    db_size_mb = os.path.getsize(DB_PATH) / (1024 * 1024)
    embedding_dim = dim1 if dim1 > 0 else dim2
    
    print(f"Exercises inserted : {len(exercises)}\n")
    print(f"Tags inserted : {goal_count + injury_count}\n")
    print(f"Embedding dimension : {embedding_dim}\n")
    print(f"Database size : {db_size_mb:.1f} MB")

if __name__ == "__main__":
    main()
