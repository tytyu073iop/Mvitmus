# Vitmus

Interactive map of Vitebsk museums with weather forecast. Flutter app for Android, iOS, Linux, and Web.

## Setup

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (stable channel).
2. Copy the weather API config:

   ```sh
   cp lib/config.example.dart lib/config.dart
   ```

   Edit `lib/config.dart` and set your [OpenWeatherMap](https://openweathermap.org/api) API key.

3. Install dependencies and run:

   ```sh
   flutter pub get
   flutter run -d linux
   ```

   Use `flutter devices` to list targets (`android`, `linux`, `chrome`, etc.).

## Tests

```sh
flutter analyze
flutter test
```

## Project structure

- `lib/` — app code (BLoC, screens, SQLite seed data, l10n)
- `assets/l10n/` — Russian, English, Belarusian strings
- `android/`, `ios/`, `linux/`, `web/` — platform runners
