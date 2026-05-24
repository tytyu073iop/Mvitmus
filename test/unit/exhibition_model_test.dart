import 'package:flutter_test/flutter_test.dart';
import 'package:vitmus/models/exhibition.dart';

void main() {
  group('Exhibition model', () {
    test('supports value equality', () {
      final a = Exhibition(
        id: 1,
        museumId: 1,
        nameRu: 'Постоянная экспозиция',
        nameEn: 'Permanent Exhibition',
        nameBe: 'Пастаянная экспазіцыя',
        descRu: 'Основная коллекция',
        descEn: 'Main collection',
        descBe: 'Асноўная калекцыя',
        startDate: '2024-01-01',
        endDate: '2024-12-31',
        price: 8.0,
      );
      final b = Exhibition(
        id: 1,
        museumId: 1,
        nameRu: 'Постоянная экспозиция',
        nameEn: 'Permanent Exhibition',
        nameBe: 'Пастаянная экспазіцыя',
        descRu: 'Основная коллекция',
        descEn: 'Main collection',
        descBe: 'Асноўная калекцыя',
        startDate: '2024-01-01',
        endDate: '2024-12-31',
        price: 8.0,
      );
      expect(a, equals(b));
    });

    test('getName returns correct locale', () {
      final e = Exhibition(
        id: 1,
        museumId: 1,
        nameRu: 'Постоянная экспозиция',
        nameEn: 'Permanent Exhibition',
        nameBe: 'Пастаянная экспазіцыя',
        descRu: '',
        descEn: '',
        descBe: '',
        startDate: '2024-01-01',
        endDate: '2024-12-31',
        price: 0.0,
      );
      expect(e.getName('ru'), 'Постоянная экспозиция');
      expect(e.getName('en'), 'Permanent Exhibition');
      expect(e.getName('be'), 'Пастаянная экспазіцыя');
    });

    test('props contain all fields', () {
      final e = Exhibition(
        id: 1,
        museumId: 2,
        nameRu: 'a',
        nameEn: 'b',
        nameBe: 'c',
        descRu: 'd',
        descEn: 'e',
        descBe: 'f',
        startDate: '2024-01-01',
        endDate: '2024-12-31',
        price: 0.0,
      );
      expect(e.props, [
        1, 2, 'a', 'b', 'c', 'd', 'e', 'f',
        '2024-01-01', '2024-12-31', 0.0,
      ]);
    });
  });
}
