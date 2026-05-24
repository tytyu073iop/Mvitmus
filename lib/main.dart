import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app.dart';
import 'bloc/map_bloc.dart';
import 'bloc/weather_bloc.dart';
import 'database/database_helper.dart';
import 'l10n/l10n.dart';
import 'repositories/museum_repository.dart';
import 'repositories/weather_repository.dart';
import 'repositories/settings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final l10n = L10n();
  await l10n.load(L10n.defaultLocale);

  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('Database init error: $e');
  }

  final museumRepo = MuseumRepository(DatabaseHelper.instance);
  final weatherRepo = WeatherRepository();
  final settingsRepo = SettingsRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MapBloc(museumRepo)),
        BlocProvider(create: (_) => WeatherBloc(weatherRepo)),
        RepositoryProvider.value(value: museumRepo),
        RepositoryProvider.value(value: weatherRepo),
        RepositoryProvider.value(value: settingsRepo),
      ],
      child: VitmusApp(l10n: l10n),
    ),
  );
}
