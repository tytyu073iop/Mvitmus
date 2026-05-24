import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vitmus/bloc/map_bloc.dart';
import 'package:vitmus/models/district.dart';
import 'package:vitmus/repositories/museum_repository.dart';
import 'package:latlong2/latlong.dart';

class MockMuseumRepository extends Mock implements MuseumRepository {}

void main() {
  late MockMuseumRepository repository;
  late MapBloc bloc;

  setUp(() {
    repository = MockMuseumRepository();
    bloc = MapBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });

  group('MapBloc', () {
    final testDistrict = const District(
      id: 1,
      nameRu: 'Железнодорожный район',
      nameEn: 'Zheleznodorozhny District',
      nameBe: 'Чыгуначны раён',
      center: LatLng(55.19, 30.20),
      polygon: [LatLng(55.19, 30.20), LatLng(55.20, 30.21)],
    );

    test('initial state is MapInitial', () {
      expect(bloc.state, const MapInitial());
    });

    test('emits [MapLoading, DistrictsLoaded] on LoadDistricts', () async {
      when(repository.getDistricts())
          .thenAnswer((_) async => [testDistrict]);

      final expected = [
        const MapLoading(),
        DistrictsLoaded(districts: [testDistrict]),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const LoadDistricts());
    });

    test('emits MapError when repository throws', () async {
      when(repository.getDistricts()).thenThrow(Exception('DB error'));

      final expected = [
        const MapLoading(),
        isA<MapError>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const LoadDistricts());
    });

    test('emits MapError on LoadMuseums error', () async {
      when(repository.getDistricts())
          .thenAnswer((_) async => [testDistrict]);
      bloc.add(const LoadDistricts());
      await Future.delayed(Duration.zero);

      when(repository.getMuseumsByDistrict(1))
          .thenThrow(Exception('DB error'));

      final expected = [
        isA<MapError>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const LoadMuseums(1));
    });
  });
}
