import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/exceptions.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/data/datasources/price_datasource.dart';
import 'package:electricity/data/models/price_response.dart';
import 'package:electricity/domain/repositories/price_repository.dart';

class PriceRepositoryImpl implements PriceRepository {
  final PriceDataSource dataSource;

  PriceRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, PriceResponse?>> getPrices(
    String startDate,
    String endDate,
    String geoId,
  ) async {
    try {
      final data = await dataSource.getPrices(startDate, endDate, geoId);
      return Right(data);
    } on ServerException  {
      return Left(ServerFailure());
    }
  }
}
