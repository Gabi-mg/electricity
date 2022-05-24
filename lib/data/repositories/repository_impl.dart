import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/exceptions.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/data/datasources/local_datasource.dart';
import 'package:electricity/data/datasources/remote_datasource.dart';
import 'package:electricity/data/models/price_response.dart';
import 'package:electricity/domain/entities/entities.dart';
import 'package:electricity/domain/repositories/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDatasource remoteDataSource;
  final LocalDatasource localDatasource;

  RepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, PriceResponse?>> getPrices(
    String startDate,
    String endDate,
    GeoId geoId,
  ) async {
    try {
      final data = await remoteDataSource.getPrices(
        startDate,
        endDate,
        geoId.geoId,
      );
      localDatasource.setPlace(geoId);
      return Right(data);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GeoId>> getPlaceSharedPref() async {
    try {
      final data = await localDatasource.getPlace();
      return Right(data);
    } on BBDDException {
      return Left(BBDDFailure());
    }
  }
}
