import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vitmus/models/district.dart';

void main() {
  group('District model', () {
    test('supports value equality', () {
      final a = const District(
        id: 1,
        nameRu: 'Железнодорожный район',
        nameEn: 'Zheleznodorozhny District',
        nameBe: 'Чыгуначны раён',
        center: LatLng(55.19, 30.20),
        polygon: [LatLng(55.19, 30.20)],
      );
      final b = const District(
        id: 1,
        nameRu: 'Железнодорожный район',
        nameEn: 'Zheleznodorozhny District',
        nameBe: 'Чыгуначны раён',
        center: LatLng(55.19, 30.20),
        polygon: [LatLng(55.19, 30.20)],
      );
      expect(a, equals(b));
    });

    test('getName returns correct locale', () {
      final d = const District(
        id: 1,
        nameRu: 'Русское название',
        nameEn: 'English name',
        nameBe: 'Беларуская назва',
        center: LatLng(55.19, 30.20),
        polygon: [LatLng(55.19, 30.20)],
      );
      expect(d.getName('ru'), 'Русское название');
      expect(d.getName('en'), 'English name');
      expect(d.getName('be'), 'Беларуская назва');
    });

    test('props contain all fields', () {
      final d = const District(
        id: 1,
        nameRu: 'a',
        nameEn: 'b',
        nameBe: 'c',
        center: LatLng(55.19, 30.20),
        polygon: [LatLng(55.19, 30.20)],
      );
      expect(d.props, [
        1, 'a', 'b', 'c',
        const LatLng(55.19, 30.20),
        [const LatLng(55.19, 30.20)],
      ]);
    });
  });
}
