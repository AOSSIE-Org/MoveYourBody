# Security Review Report

- **Reviewing agent / model:** Gemini 3.8 Flash (High)
- **Reasoning effort / tier:** high
- **Review date and time:** 2026-10-25T11:45:25Z

## Scope

This security review covered the full repository scope of the **MoveYourBody** project at commit `e7e991849018a7e4ec08512b794c76c0cb285931`. The codebase was evaluated against the **Mobile App (Flutter)** and **General Checklist** security standards, covering data persistence (`sqflite`), local state and caching (`SharedPreferences`), on-device machine learning inference (`flutter_onnxruntime`, `dart_wordpiece`), offline audio processing and keyword recognition (`fftea`, `record`), platform manifests, and build configurations.

## Findings

### Finding 1: Missing `android:allowBackup="false"` Allows Unencrypted Application Data Extraction — `android/app/src/main/AndroidManifest.xml:7`

- Severity: Medium
- Confidence: 0.90
- Category: insecure_storage
- Description: The `<application>` element in `AndroidManifest.xml` does not explicitly set `android:allowBackup="false"`. In Android, the default configuration allows application data to be extracted via Android Debug Bridge (ADB) backup. Because MoveYourBody stores user health attributes, injuries, workout performance logs, and user profile details locally in unencrypted SQLite databases (`databases/app_database.db`), an attacker with physical or USB debugging access can extract the entire local database.
- Exploit Scenario: A user connects their Android device to an untrusted workstation or an attacker gains temporary physical access to an unlocked device with USB debugging enabled. The attacker runs `adb backup -f app_backup.ab -noapk org.aossie.move` and unpacks the backup archive using standard extraction utilities, recovering sensitive plaintext records from the local SQLite database.
- Recommendation: Add `android:allowBackup="false"` to the `<application>` tag in `android/app/src/main/AndroidManifest.xml` to prevent unauthorized ADB data backup extraction of private application databases.

### Finding 2: Unnecessary `android.permission.INTERNET` Declared in Production Manifest — `android/app/src/main/AndroidManifest.xml:2`

- Severity: Low
- Confidence: 0.85
- Category: excessive_permissions
- Description: The production Android manifest (`android/app/src/main/AndroidManifest.xml`) declares `<uses-permission android:name="android.permission.INTERNET" />`. MoveYourBody is architecturally designed and documented in `PRIVACY_POLICY.md` and `README.md` as an entirely offline, privacy-first mobile fitness application with on-device machine learning. Declaring outbound Internet access in the production manifest expands the application's attack surface and contradicts the Principle of Least Privilege.
- Exploit Scenario: If a future third-party library or supply-chain dependency is compromised or attempts telemetry, the presence of the `INTERNET` permission would permit silent outbound network communication without runtime user prompt, contrary to the app's zero-telemetry privacy guarantees.
- Recommendation: Remove `<uses-permission android:name="android.permission.INTERNET" />` from the production manifest (`android/app/src/main/AndroidManifest.xml`). If network access is required solely for Flutter developer tools (Observatory/Hot Reload) during local testing, declare the permission exclusively in `android/app/src/debug/AndroidManifest.xml`.

## Notes

### Note 1: Safe Tokenizer Input Length Bounding and Exception Guarding — `lib/data/services/tokenizer_service.dart:22`

- Category: design-tradeoff
- Observation: The WordPiece tokenizer configures a fixed maximum input length (`maxLength: 128`) and performs text normalization, with all tokenization and ONNX inference operations encapsulated in guarded `try / catch` blocks.
- Rationale: This deliberate defense-in-depth design prevents memory exhaustion, buffer over-allocation, and application crashes when processing arbitrary or excessively large search queries against the local quantized embedding model.

### Note 2: Robust Parameterized Query Construction in SQLite Layer — `lib/data/database/db_config.dart:47`

- Category: design-tradeoff
- Observation: Database operations across repositories and the database service consistently use parameterized SQL placeholders (`?` and `whereArgs`) rather than raw string concatenation.
- Rationale: The repository layer strictly abstracts and parametrizes all dynamic queries, ensuring complete protection against local SQL injection attacks.

## Limitations

### Standing limitations

- This review does not replace a full manual audit or a penetration test.
- This is static analysis of source text. Nothing was executed, fuzzed, or traced at runtime, so timing-dependent, load-dependent, or infrastructure-dependent issues cannot be confirmed here.
- Confidence scores are the reviewing model's own self-assessment, not a calibrated statistical probability.
- Absence of a reported finding does not mean the code is secure. Safety guardrails built into some models can cause a real vulnerability to be softened, generalized, or left out rather than reported in exploit-level detail, and training-data bias can make some vulnerability classes easier for a model to recognize than others. Treat this report as a floor on what a full audit would find, not a ceiling.
- Findings reflect the reviewing model's training data cutoff. A vulnerability tied to a very recently disclosed CVE or library advisory may not be recognized as such.

### Review-specific limitations

No review-specific limitations beyond the standing ones above.
