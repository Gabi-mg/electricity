import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/data/mapper.dart';
import 'package:electricity/domain/entities/prices.dart';
import 'package:electricity/domain/repositories/price_repository.dart';
import 'package:electricity/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class PriceUsecase implements UseCase<Prices, PricesParams> {
  final PriceRepository repository;

  PriceUsecase(this.repository);

  @override
  Future<Either<Failure, Prices>> call(PricesParams params) async {
    final response = await repository.getPrices(
        params.startDate, params.endDate, params.geoId);

    return response.fold(
      (l) => Left(l),
      (r) => Right(Mapper.transformPricesResponse(r!)),
    );
  }
}

class PricesParams extends Equatable {
  final String startDate;
  final String endDate;
  final String geoId;

  const PricesParams(this.startDate, this.endDate, this.geoId) : super();

  @override
  List<Object?> get props => [startDate, endDate, geoId];
}
