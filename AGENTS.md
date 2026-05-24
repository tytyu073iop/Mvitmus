# AGENTS.md — vitmus

## Commands

```sh
flutter pub get
flutter analyze
flutter analyze lib/
flutter analyze test/
flutter test
flutter run -d linux    # or android, chrome (with CHROME_EXECUTABLE set)
```

## Architecture

- **State**: `flutter_bloc` + `equatable` — `MapBloc` (districts/museums) and `WeatherBloc`, both in `MultiBlocProvider` in `lib/main.dart`
- **Localization**: Custom manual loader (`lib/l10n/l10n.dart`), no `flutter gen-l10n`. 3 ARB files in `assets/l10n/` (en, ru, be)
- **Persistence**: `sqflite` via `DatabaseHelper`; `shared_preferences` via `SettingsRepository`
- **Entrypoint**: `lib/main.dart` → `VitmusApp` (`lib/app.dart`) → `MapScreen` (`lib/screens/map_screen.dart`)

## Localization quirks

- ARB files **must** be listed in `pubspec.yaml` under `flutter: assets:` or they won't bundle
- Copy `lib/config.example.dart` to `lib/config.dart` and set `weatherApiKey` for OpenWeatherMap

## Platforms

- **Android / iOS / Linux / Web** — standard Flutter embedding (`android/`, `ios/`, `linux/`, `web/`)
- Package id: `com.vitmus.vitmus`

## Conventions

- Single quotes preferred (`prefer_single_quotes: true` in `analysis_options.yaml`)
- BLoC events extend `Equatable`, states are immutable with `copyWith`
- `debugPrint` for error logging in repositories
