import 'package:equatable/equatable.dart';

class Exhibition extends Equatable {
  final int id;
  final int museumId;
  final String nameRu;
  final String nameEn;
  final String nameBe;
  final String descRu;
  final String descEn;
  final String descBe;
  final String startDate;
  final String endDate;
  final double price;

  const Exhibition({
    required this.id,
    required this.museumId,
    required this.nameRu,
    required this.nameEn,
    required this.nameBe,
    required this.descRu,
    required this.descEn,
    required this.descBe,
    required this.startDate,
    required this.endDate,
    required this.price,
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

  @override
  List<Object?> get props => [
        id,
        museumId,
        nameRu,
        nameEn,
        nameBe,
        descRu,
        descEn,
        descBe,
        startDate,
        endDate,
        price,
      ];
}
