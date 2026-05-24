import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vitmus/models/museum.dart';

void main() {
  group('Museum model', () {
    test('supports value equality', () {
      final a = Museum(
        id: 1,
        districtId: 1,
        nameRu: 'Художественный музей',
        nameEn: 'Art Museum',
        nameBe: 'Мастацкі музей',
        descRu: 'Коллекция искусства',
        descEn: 'Art collection',
        descBe: 'Калекцыя мастацтва',
        addressRu: 'ул. Ленина, 32',
        addressEn: 'Lenina st., 32',
        addressBe: 'вул. Леніна, 32',
        location: const LatLng(55.1925, 30.2030),
      );
      final b = Museum(
        id: 1,
        districtId: 1,
        nameRu: 'Художественный музей',
        nameEn: 'Art Museum',
        nameBe: 'Мастацкі музей',
        descRu: 'Коллекция искусства',
        descEn: 'Art collection',
        descBe: 'Калекцыя мастацтва',
        addressRu: 'ул. Ленина, 32',
        addressEn: 'Lenina st., 32',
        addressBe: 'вул. Леніна, 32',
        location: const LatLng(55.1925, 30.2030),
      );
      expect(a, equals(b));
    });

    test('getName/getDescription/getAddress return correct locale', () {
      final m = Museum(
        id: 1,
        districtId: 1,
        nameRu: 'Русское название',
        nameEn: 'English name',
        nameBe: 'Беларуская назва',
        descRu: 'Русское описание',
        descEn: 'English description',
        descBe: 'Беларускае апісанне',
        addressRu: 'Русский адрес',
        addressEn: 'English address',
        addressBe: 'Беларускі адрас',
        location: const LatLng(55.19, 30.20),
      );
      expect(m.getName('ru'), 'Русское название');
      expect(m.getName('en'), 'English name');
      expect(m.getName('be'), 'Беларуская назва');
      expect(m.getDescription('ru'), 'Русское описание');
      expect(m.getDescription('en'), 'English description');
      expect(m.getDescription('be'), 'Беларускае апісанне');
      expect(m.getAddress('ru'), 'Русский адрес');
      expect(m.getAddress('en'), 'English address');
      expect(m.getAddress('be'), 'Беларускі адрас');
    });
  });
}
