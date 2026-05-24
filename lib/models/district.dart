import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class District extends Equatable {
  final int id;
  final String nameRu;
  final String nameEn;
  final String nameBe;
  final LatLng center;
  final List<LatLng> polygon;

  const District({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.nameBe,
    required this.center,
    required this.polygon,
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

  @override
  List<Object?> get props => [id, nameRu, nameEn, nameBe, center, polygon];
}
