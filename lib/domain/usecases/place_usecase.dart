import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/domain/entities/entities.dart';
import 'package:electricity/domain/repositories/repository.dart';
import 'package:electricity/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class PlaceUsecase implements UseCase<GeoId, PlaceParams> {
  final Repository repository;

  PlaceUsecase(this.repository);

  @override
  Future<Either<Failure, GeoId>> call(PlaceParams? params) async {
    final response = await repository.getPlaceSharedPref();

    return response.fold(
      (failure) => Left(failure),
      (place) => Right(place),
    );
  }
}

class PlaceParams extends Equatable {
  const PlaceParams() : super();

  @override
  List<Object?> get props => [];
}
