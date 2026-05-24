import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vitmus/bloc/map_bloc.dart';
import 'package:vitmus/l10n/l10n.dart';
import 'package:vitmus/models/district.dart';
import 'package:vitmus/repositories/museum_repository.dart';
import 'package:vitmus/screens/map_screen.dart';

class _TestRepository extends MuseumRepository {
  _TestRepository() : super.forTest();

  @override
  Future<List<District>> getDistricts() async {
    return [
      const District(
        id: 1,
        nameRu: 'Тестовый район',
        nameEn: 'Test District',
        nameBe: 'Тэставы раён',
        center: LatLng(55.19, 30.20),
        polygon: [LatLng(55.19, 30.20), LatLng(55.20, 30.21)],
      ),
    ];
  }
}

void main() {
  group('MapScreen widget', () {
    late L10n l10n;

    setUp(() async {
      l10n = L10n();
      await l10n.load('en');
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: l10n,
          child: MaterialApp(
            home: BlocProvider(
              create: (_) => MapBloc(_TestRepository()),
              child: MapScreen(onLocaleChanged: (_) {}),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows map after loading districts', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: l10n,
          child: MaterialApp(
            home: BlocProvider(
              create: (_) => MapBloc(_TestRepository()),
              child: MapScreen(onLocaleChanged: (_) {}),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });
  });
}
