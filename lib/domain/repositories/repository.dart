import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/data/models/price_response.dart';
import 'package:electricity/domain/entities/entities.dart';

abstract class Repository {
  Future<Either<Failure, PriceResponse?>> getPrices(
    String starDate,
    String endDate,
    GeoId geoId,
  );

  Future<Either<Failure, GeoId>> getPlaceSharedPref();
}
