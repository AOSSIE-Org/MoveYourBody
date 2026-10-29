<!-- Don't delete it -->
<div name="readme-top"></div>

<!-- Organization Logo -->
<div align="center" style="display: flex; align-items: center; justify-content: center; gap: 16px;">
  <img alt="AOSSIE" src="public/aossie-logo.svg" width="175">
  <img alt="Move Your Body Logo" src="public/MoveYourBodyLogo.svg" width="175" />
</div>

&nbsp;

<!-- Organization Name -->
<div align="center">
  <a href="https://aossie.org/"><img src="https://img.shields.io/badge/aossie.org/MoveYourBody-228B22?style=for-the-badge&labelColor=FFC517" alt="Static Badge"></a>
</div>

<!-- Organization/Project Social Handles -->
<p align="center">
<!-- Telegram -->
<a href="https://t.me/StabilityNexus">
<img src="https://img.shields.io/badge/Telegram-black?style=flat&logo=telegram&logoColor=white&logoSize=auto&color=24A1DE" alt="Telegram Badge"/></a>
&nbsp;&nbsp;
<!-- X (formerly Twitter) -->
<a href="https://x.com/aossie_org">
<img src="https://img.shields.io/twitter/follow/aossie_org" alt="X (formerly Twitter) Badge"/></a>
&nbsp;&nbsp;
<!-- Discord -->
<a href="https://discord.com/channels/1022871757289422898/1500966300782956634">
<img src="https://img.shields.io/discord/1022871757289422898?style=flat&logo=discord&logoColor=white&logoSize=auto&label=Discord&labelColor=5865F2&color=57F287" alt="Discord Badge"/></a>
&nbsp;&nbsp;
<!-- Medium -->
<a href="https://news.stability.nexus/">
  <img src="https://img.shields.io/badge/Medium-black?style=flat&logo=medium&logoColor=black&logoSize=auto&color=white" alt="Medium Badge"></a>
&nbsp;&nbsp;
<!-- LinkedIn -->
<a href="https://www.linkedin.com/company/aossie/">
  <img src="https://img.shields.io/badge/LinkedIn-black?style=flat&logo=LinkedIn&logoColor=white&logoSize=auto&color=0A66C2" alt="LinkedIn Badge"></a>
&nbsp;&nbsp;
<!-- Youtube -->
<a href="https://www.youtube.com/@AOSSIE-Org">
  <img src="https://img.shields.io/youtube/channel/subscribers/UCKVVLbawY7Gej_3o2WKsoiA?style=flat&logo=youtube&logoColor=white%20&logoSize=auto&labelColor=FF0000&color=FF0000" alt="Youtube Badge"></a>
</p>

---

<div align="center">
<h1>MoveYourBody</h1>
<a href="https://play.google.com/store/apps/details?id=org.aossie.move"><img src="https://img.shields.io/badge/Google_Play-Get_It_On-green?style=for-the-badge&logo=google-play&logoColor=white" alt="Google Play"></a>
<br/>
<br/>
<a href="https://securityscorecards.dev/viewer/?url=github.com/AOSSIE-Org/MoveYourBody"><img src="https://api.securityscorecards.dev/projects/github.com/AOSSIE-Org/MoveYourBody/badge" alt="OpenSSF Scorecard"></a>
</div>

**MoveYourBody** is a privacy-first, on-device fitness application designed to help you stay consistent with your goals. It provides personalized, short micro-workout sessions (5–7 minutes) that adapt based on your feedback and health conditions. By running completely offline, MoveYourBody combines rule-based filtering and lightweight semantic matching to ensure your workout data stays entirely private while delivering safe, relevant, and engaging exercises.

---

## 🚀 Features

- **Micro-Workout Sessions**: Stay consistent with short, 5-7 minute micro-sessions. You'll receive 2-3 sessions per day, with each session consisting of 3 exercises, complete with built-in notifications.
- **Personalized Exercise Selection**: Uses an on-device embedding pipeline to match exercises to your goals. It avoids recently performed exercises to prevent boredom, filters out unsafe movements based on your injuries, and adapts difficulty through post-workout feedback.
- **High-Quality Animations & Guidance**: Understand every movement with crystal-clear animations and instructions that teach you the correct posture.
- **Voice-Controlled Interface**: Enjoy a hands-free workout experience with voice commands to start, pause, skip, or repeat instructions during a session.
- **Body Focus Workouts**: Want to target a specific muscle group? Choose from pre-defined sessions tailored for quick, muscle-specific training.
- **Custom Workout Creation**: Take full control. Explore a database of over 100+ exercises to learn, mix, and build your own custom, flexible workout routines.
- **Progress & Motivation**: Visualize your consistency and fitness journey with an interactive stats screen, calendar views, and performance charts.
- **Privacy-First & 100% Offline**: Everything runs on-device. Your health data, feedback, and embedded semantic searches never leave your phone.

---

## 💻 Tech Stack

### Mobile Frontend
- **Framework**: Flutter
- **State Management**: Riverpod
- **Routing**: GoRouter
- **UI/Animations**: Lottie, Video Player, Google Fonts, FL Chart

### Local Backend & Data
- **Database**: SQLite (`sqflite`)
- **Caching**: Shared Preferences, Flutter Cache Manager
- **Search Utilities**: Fuzzy string matching

### On-Device AI
- **Inference**: Flutter ONNX Runtime
- **Tokenization**: Dart WordPiece
- **Models**: [all-MiniLM-L6-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2) (Quantized ONNX model running directly on-device via `assets/models/model_quantized.onnx`)

### Audio & Offline Voice Pipeline
- **Text-to-Speech (TTS)**: `flutter_tts` for voice coaching and exercise announcements
- **Audio Recording**: `record` (PCM 16-bit 16kHz audio stream)
- **Feature Extraction**: `fftea` (Fast Fourier Transform for Mel-Frequency Cepstral Coefficients / MFCC)
- **Pattern Matching**: Dynamic Time Warping (DTW) for real-time on-device keyword recognition (e.g., "pause", "resume", "skip")

---

## ✅ Project Checklist

- [x] **The mobile app**:
   - [ ] has an _About_ page containing the Stability Nexus's logo and pointing to the social media accounts of the Stability Nexus.
   - [x] is available for download as a release in this repo.
   - [x] is available in the relevant app stores ([Google Play Store](https://play.google.com/store/apps/details?id=org.aossie.move)).
- [x] **The AI/ML components**:
   - [x] LLM/model selection and configuration are documented.
      - **Model Selection**: [all-MiniLM-L6-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2) was chosen because it is designed specifically for sentence similarity tasks. It provides low latency and fast inference which is highly suitable for on-device cases (see [Research Paper](https://www.researchgate.net/publication/377627749_Performance_of_4_Pre-Trained_Sentence_Transformer_Models_in_the_Semantic_Query_of_a_Systematic_Review_Dataset_on_Peri-Implantitis)).
      - **Configuration**: ONNX models are quantized and bundled locally in assets, with tokenization logic strictly handled on-device.
      - ![Model Selection](public/model_selection.png)
   - [ ] Prompts and system instructions are version-controlled.
   - [ ] Content safety and moderation mechanisms are implemented.
   - [ ] API keys and rate limits are properly managed.

---

## 🔗 Repository Links

1. [Main Repository](https://github.com/AOSSIE-Org/MoveYourBody)

---

## 🏗️ Architecture

### 1. High-Level MVVM Architecture

The application follows a robust **Model-View-ViewModel (MVVM) with Repository Pattern** architecture, utilizing Riverpod as the reactive state-management (ViewModel) layer to keep the UI strictly separated from the business and data logic.

```mermaid
graph TD
    %% Define Styles
    classDef ui fill:#1A2E1A,stroke:#4CAF50,stroke-width:2px,color:#fff;
    classDef vm fill:#254025,stroke:#81C784,stroke-width:2px,color:#fff;
    classDef domain fill:#122412,stroke:#2E7D32,stroke-width:2px,color:#fff;
    classDef data fill:#0A1A0A,stroke:#66BB6A,stroke-width:2px,color:#fff;
    classDef service fill:#1b381b,stroke:#81C784,stroke-width:1.5px,color:#fff;

    subgraph ViewLayer ["View Layer (lib/ui/)"]
        UI["Flutter UI / Screens"]:::ui
        Widgets["Custom Widgets"]:::ui
    end

    subgraph ViewModelLayer ["ViewModel Layer (lib/ui/**/view_models/)"]
        Riverpod["Riverpod Notifiers & Providers"]:::vm
        Router["GoRouter State"]:::vm
    end

    subgraph DomainLayer ["Domain Layer (lib/domain/)"]
        DomainModels["Domain Models (Exercise, Userdata, Session, DayPlan)"]:::domain
    end

    subgraph DataLayer ["Data Layer (lib/data/)"]
        Repositories["Repositories (UserRepository, SessionRepository, etc.)"]:::data
        
        subgraph Services ["Services (lib/data/services/)"]
            AIServices["OnnxService & TokenizerService"]:::service
            VoiceServices["VoiceCommandDetector & TtsService"]:::service
            NotifServices["NotificationService"]:::service
            CacheServices["AnimationCacheService"]:::service
        end

        subgraph LocalStorage ["Local Storage"]
            DB[("SQLite (sqflite)")]:::data
            Cache[("Shared Preferences")]:::data
        end
    end

    %% Flow of MVVM & Clean Architecture
    UI -->|User Intent & UI Events| Riverpod
    Riverpod -->|Reactive State Updates| UI
    
    Riverpod -->|Fetch / Process Business Logic| Repositories
    Riverpod -->|Voice Control & Audio Coaching| VoiceServices
    Riverpod -->|Schedule Workout Reminders| NotifServices
    
    Repositories -->|Uses Entities| DomainModels
    Repositories -->|Query / Mutate| DB
    Repositories -->|Cache Data| Cache
    Repositories -->|Semantic Embeddings & Tokenization| AIServices
    AIServices -->|Inference Results| DomainModels
```

- **View Layer (`lib/ui/`)**: Contains modular Flutter screens and reusable UI components. Responsible solely for rendering state and capturing user input and gesture events.
- **ViewModel Layer (`lib/ui/**/view_models/` & `lib/routing/`)**: Acts as the reactive bridge between the View and Data/Domain layers. Holds presentation logic, manages UI state via Riverpod, coordinates audio coaching/voice command services, and handles navigation via GoRouter.
- **Domain Layer (`lib/domain/`)**: Contains core domain entities and data models (`Exercise`, `Userdata`, `WorkoutSession`, `DayPlan`, etc.) independent of external libraries or frameworks.
- **Data Layer (`lib/data/`)**: Handles all data coordination and operations:
  - **Repositories (`lib/data/repositories/`)**: Abstract data access and provide unified APIs for user profiles, workout sessions, exercise recommendations, and AI models.
  - **Services (`lib/data/services/`)**: Encapsulate device-level capabilities such as on-device AI embedding inference (`OnnxService`), tokenization (`TokenizerService`), offline voice keyword detection (`VoiceCommandDetector`), text-to-speech coaching (`TtsService`), local scheduled reminders (`NotificationService`), and media caching (`AnimationCacheService`).
  - **Local Storage (`lib/data/database/`)**: Manages offline persistence with SQLite (`sqflite`) and user preferences caching with `SharedPreferences`.

### 2. Custom Input to Tags Pipeline

![Custom Input to Tags Pipeline](public/custom_input_to_tags_pipeline.png)
*(Illustrates how user input is processed and mapped to semantic tags)*

### 3. Recommendation Algorithm Overview

![Recommendation Algorithm Overview](public/recommendation_algorithm_overview.png)
*(Overview of rule-based filtering, injury exclusion, and semantic matching)*

### 4. Voice Control Pipeline

![Voice Control Pipeline](public/Voice_Control_Pipeline.png)
*(Flowchart detailing how voice commands are captured, processed, and executed)*

---

## 🔄 User Flow

```text
User opens the app
        ↓
User completes onboarding (details, goals, injuries)
        ↓
Algorithm & AI create a personalized micro-session
        ↓
User executes and completes the workout session
        ↓
User submits post-workout ratings and feedback
        ↓
System adapts and tailors the next session based on feedback
        ↓
User receives notification when the next customized session is ready
```

---

## 🍀 Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / Xcode (for emulation and building)

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/AOSSIE-Org/MoveYourBody.git
cd MoveYourBody
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Generate Riverpod Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 4. Generate Exercise Database

Run the provided Python script to set up the local exercise database.

```bash
python scripts/generate_exercise_db.py
```

#### 5. Run the Application

Ensure you have a simulator running or a device connected.

```bash
flutter run
```

#### 6. Code Quality & Testing (CI Checks)

To verify that your code adheres to project standards and passes CI ([`.github/workflows/test.yml`](.github/workflows/test.yml)):

```bash
# Format code
dart format .

# Run static analysis
flutter analyze

# Run automated tests
flutter test
```

---

## 📱 App Screenshots

| | | |
|:---:|:---:|:---:|
| ![Screenshot 1](public/app_ss_1.png) | ![Screenshot 2](public/app_ss_2.png) | ![Screenshot 3](public/app_ss_3.png) |

---

## 🙌 Contributing

⭐ Don't forget to star this repository if you find it useful! ⭐

Thank you for considering contributing to this project! Contributions are highly appreciated and welcomed, read the [CONTRIBUTING.md](./CONTRIBUTING.md) for setting the project.

*Note: Before opening a UI Pull Request, please ensure you read our [brand.md](./brand/brand.md) file for styling guidelines.*

---

## 📍 License

This project is licensed under the GNU General Public License v3.0.
See the [LICENSE](LICENSE) file for details.

---

## 💪 Thanks To All Contributors

Thanks a lot for spending your time helping MoveYourBody grow. Keep rocking 🥂

[![Contributors](https://contrib.rocks/image?repo=AOSSIE-Org/MoveYourBody)](https://github.com/AOSSIE-Org/MoveYourBody/graphs/contributors)

© 2026 AOSSIE
