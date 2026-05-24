import 'package:flutter_test/flutter_test.dart';
import 'package:vitmus/bloc/map_bloc.dart';
import 'package:vitmus/models/district.dart';
import 'package:vitmus/models/museum.dart';
import 'package:vitmus/models/exhibition.dart';
import 'package:vitmus/repositories/museum_repository.dart';
import 'package:latlong2/latlong.dart';

class MockMuseumRepository implements MuseumRepository {
  Future<List<District>> Function()? mockGetDistricts;
  Future<List<Museum>> Function(int)? mockGetMuseumsByDistrict;

  @override
  Future<List<District>> getDistricts() {
    if (mockGetDistricts != null) return mockGetDistricts!();
    throw UnimplementedError('mockGetDistricts not set');
  }

  @override
  Future<List<Museum>> getMuseumsByDistrict(int districtId) {
    if (mockGetMuseumsByDistrict != null) {
      return mockGetMuseumsByDistrict!(districtId);
    }
    throw UnimplementedError('mockGetMuseumsByDistrict not set');
  }

  @override
  Future<List<Exhibition>> getExhibitionsByMuseum(int museumId) {
    throw UnimplementedError('getExhibitionsByMuseum not expected');
  }
}

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
      repository.mockGetDistricts = () async => [testDistrict];

      final expected = [
        const MapLoading(),
        DistrictsLoaded(districts: [testDistrict]),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const LoadDistricts());
    });

    test('emits MapError when repository throws', () async {
      repository.mockGetDistricts = () => throw Exception('DB error');

      final expected = [
        const MapLoading(),
        isA<MapError>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const LoadDistricts());
    });

    test('emits MapError on LoadMuseums error', () async {
      repository.mockGetDistricts = () async => [testDistrict];
      bloc.add(const LoadDistricts());
      await Future.delayed(Duration.zero);

      repository.mockGetMuseumsByDistrict = (id) => throw Exception('DB error');

      final expected = [
        isA<MapError>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const LoadMuseums(1));
    });
  });
}
