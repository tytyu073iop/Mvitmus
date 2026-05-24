import 'package:vitmus/database/database_helper.dart';
import 'package:vitmus/models/district.dart';
import 'package:vitmus/models/museum.dart';
import 'package:vitmus/models/exhibition.dart';
import 'package:flutter/foundation.dart';

class MuseumRepository {
  final DatabaseHelper _db;

  MuseumRepository(this._db);

  MuseumRepository.forTest() : _db = DatabaseHelper.instance;

  Future<List<District>> getDistricts() async {
    try {
      return await _db.getDistricts();
    } catch (e) {
      debugPrint('Error loading districts: $e');
      rethrow;
    }
  }

  Future<List<Museum>> getMuseumsByDistrict(int districtId) async {
    try {
      return await _db.getMuseumsByDistrict(districtId);
    } catch (e) {
      debugPrint('Error loading museums for district $districtId: $e');
      rethrow;
    }
  }

  Future<List<Exhibition>> getExhibitionsByMuseum(int museumId) async {
    try {
      return await _db.getExhibitionsByMuseum(museumId);
    } catch (e) {
      debugPrint('Error loading exhibitions for museum $museumId: $e');
      rethrow;
    }
  }
}
