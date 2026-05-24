import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class Museum extends Equatable {
  final int id;
  final int districtId;
  final String nameRu;
  final String nameEn;
  final String nameBe;
  final String descRu;
  final String descEn;
  final String descBe;
  final String addressRu;
  final String addressEn;
  final String addressBe;
  final LatLng location;

  const Museum({
    required this.id,
    required this.districtId,
    required this.nameRu,
    required this.nameEn,
    required this.nameBe,
    required this.descRu,
    required this.descEn,
    required this.descBe,
    required this.addressRu,
    required this.addressEn,
    required this.addressBe,
    required this.location,
  });

  String getName(String locale) {
    switch (locale) {
      case 'ru':
        return nameRu;
      case 'be':
        return nameBe;
      default:
        return nameEn;
    }
  }

  String getDescription(String locale) {
    switch (locale) {
      case 'ru':
        return descRu;
      case 'be':
        return descBe;
      default:
        return descEn;
    }
  }

  String getAddress(String locale) {
    switch (locale) {
      case 'ru':
        return addressRu;
      case 'be':
        return addressBe;
      default:
        return addressEn;
    }
  }

  @override
  List<Object?> get props => [
        id,
        districtId,
        nameRu,
        nameEn,
        nameBe,
        descRu,
        descEn,
        descBe,
        addressRu,
        addressEn,
        addressBe,
        location,
      ];
}
