import 'dart:convert';

import 'package:electricity/common/errors/exceptions.dart';
import 'package:electricity/common/utils/constants.dart';
import 'package:electricity/domain/entities/entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {
  Future<GeoId> getPlace();

  Future<void> setPlace(GeoId geoId);

  LocalDatasource();
}

class LocalDatasourceImpl extends LocalDatasource {
  final SharedPreferences sharedPreferences;

  LocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<GeoId> getPlace() {
    String? place = sharedPreferences.getString(placeSharedPref);

    if (place == null) {
      throw BBDDException();
    }

    return Future.value(GeoId.fromJson(jsonDecode(place)));
  }

  @override
  Future<void> setPlace(GeoId geoId) {
    return sharedPreferences.setString(placeSharedPref, jsonEncode(geoId));
  }
}
