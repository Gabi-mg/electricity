import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/common/utils/utils.dart';
import 'package:electricity/domain/entities/entities.dart';
import 'package:electricity/domain/usecases/place_usecase.dart';
import 'package:equatable/equatable.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceUsecase placeUsecase;

  final List<GeoId> geoIds = Utils.getGeoIds();

  PlaceBloc({
    required this.placeUsecase,
  }) : super(const PlaceLoadingState()) {
    on<LoadingPlaceEvent>(
      (event, emit) async {
        emit(const PlaceLoadingState());
        GeoId geoId = geoIds[0];
        final response = await _getPlace();
        response.fold(
          (failure) => geoId = geoIds[0],
          (geo) => geoId = geo,
        );
        emit(PlaceLoadedState(geoId: geoId));
      },
    );
  }

  Future<Either<Failure, GeoId>> _getPlace() async {
    final response = await placeUsecase.call(null);
    return response;
  }
}
