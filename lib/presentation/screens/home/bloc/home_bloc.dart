import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/common/utils/utils.dart';
import 'package:electricity/domain/entities/entities.dart';
import 'package:electricity/domain/usecases/price_usecase.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PriceUsecase priceUsecase;
  final List<GeoId> geoIds = Utils.getGeoIds();

  late DateTime date;
  late GeoId geoId;
  late double valueMax;
  late double valueMin;

  HomeBloc(this.priceUsecase) : super(const HomeLoadingState()) {
    on<LoadingEvent>(
      (event, emit) async {
        emit(const HomeLoadingState());
        final prices = await _getPrices();
        prices.fold(
          (failure) => emit(const HomeErrorState()),
          (prices) {
            valueMax = _getValueMax(prices.included.attributes.values);
            valueMin = _getValueMin(prices.included.attributes.values);
            emit(HomeLoadedState(newPrices: prices));
          },
        );
      },
    );
  }

  Future<Either<Failure, Prices>> _getPrices() async {
    date = DateTime(date.year, date.month, date.day);
    String startDate = date.toIso8601String();
    String endDate =
        date.add(const Duration(hours: 23, minutes: 59)).toIso8601String();
    PricesParams params = PricesParams(
      startDate,
      endDate,
      geoId.geoId,
    );
    final response = await priceUsecase.call(params);
    return response;
  }

  IntervalEnum getInterval(List<Value> values, Value currentValue) {
    double interval = (valueMax - valueMin) / 3; //three parts
    if ((valueMin + interval) > currentValue.value) {
      return IntervalEnum.interval1;
    } else if ((valueMax - interval) < currentValue.value) {
      return IntervalEnum.interval3;
    } else {
      return IntervalEnum.interval2;
    }
  }

  double _getValueMax(List<Value> values) {
    double valueMax = values[0].value;

    for (Value item in values) {
      if (item.value > valueMax) {
        valueMax = item.value;
      }
    }
    return valueMax;
  }

  double _getValueMin(List<Value> values) {
    double valueMin = values[0].value;

    for (Value item in values) {
      if (item.value < valueMin) {
        valueMin = item.value;
      }
    }
    return valueMin;
  }

  bool isValueMax(double currentValue) {
    return currentValue == valueMax;
  }

  bool isValueMin(double currentValue) {
    return currentValue == valueMin;
  }

  bool isValueNow(Value value) {
    if (value.datetime.day == DateTime.now().day &&
        value.datetime.month == DateTime.now().month &&
        value.datetime.year == DateTime.now().year &&
        value.datetime.hour < DateTime.now().hour + 1 &&
        value.datetime.hour >= DateTime.now().hour) {
      return true;
    }
    return false;
  }
}
