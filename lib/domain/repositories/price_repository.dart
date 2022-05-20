import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/data/models/price_response.dart';

abstract class PriceRepository {
  Future<Either<Failure, PriceResponse?>> getPrices(
    String starDate,
    String endDate,
    String geoId,
      );
}
