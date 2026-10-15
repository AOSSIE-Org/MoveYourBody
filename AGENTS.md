# MoveYourBody

Flutter/Dart mobile application.

- State management: Riverpod.
- Local storage: SQLite via sqflite and Shared Preferences.
- Backend/cloud services: None. This is a fully offline, privacy-first application with on-device AI.

## Commands

- Install dependencies: `flutter pub get`
- Generate Riverpod Code: `dart run build_runner build --delete-conflicting-outputs`
- Generate Exercise Database: `python scripts/generate_exercise_db.py` (Must run before flutter run)
- Run: `flutter run`
- Test: `flutter test`
- Analyze: `flutter analyze`
- Format: `dart format .`

## Code Style

- **Dart Conventions**: Strictly adhere to the official Effective Dart guidelines. Ensure your code passes `dart analyze` without introducing any new warnings or issues.
- **Immutability First**: Always use `final` for variables unless mutation is strictly required. For UI components, extensively use `const` constructors to optimize Flutter's rendering performance.
- **Widget Composition**: Do not dump everything into a massive `build()` method. Break down complex UIs into smaller, logical, and stateless private widgets.

## Architecture

We follow a strict Model-View-ViewModel (MVVM) with Repository Pattern.

`lib/features/` — contains a folder for each individual feature. Each feature should contain its own UI, ViewModels (Riverpod), and Repositories.

`lib/generated/` — contains auto-generated code.

Keep feature-specific logic inside its respective feature directory.

Database logic should be kept separate from UI and feature presentation code, abstracted within the Repository layer.

Use the project's database helper for database access rather than creating database connections directly throughout the application.

Access external models (like ONNX runtime) and databases through appropriate repositories or providers. Do not call them directly from widgets.

## Testing

Testing setup exists (`flutter test` runs), but follow the project's existing testing conventions when adding tests.

If no established testing pattern exists, ask before introducing a new style.

## Boundaries

Never commit API keys, credentials, or other secrets.

Follow the project's privacy and data-handling requirements (fully offline).

Do not introduce new external services, analytics, telemetry, cloud storage, or network-dependent functionality without explicit project requirements. All ML inference (all-MiniLM-L6-v2) must remain on-device.

## Git

Use Conventional Commits:

`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`

Branch naming:

`feature/short-description`
`fix/short-description`
