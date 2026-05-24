import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'l10n/l10n.dart';
import 'screens/map_screen.dart';

class VitmusApp extends StatefulWidget {
  final L10n l10n;

  const VitmusApp({super.key, required this.l10n});

  @override
  State<VitmusApp> createState() => _VitmusAppState();
}

class _VitmusAppState extends State<VitmusApp> {
  void _switchLocale(String locale) async {
    await widget.l10n.load(locale);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget.l10n,
      child: MaterialApp(
        title: widget.l10n.translate('appName'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) => MapScreen(onLocaleChanged: _switchLocale),
        ),
      ),
    );
  }
}
