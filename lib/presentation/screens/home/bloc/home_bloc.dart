import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:electricity/common/errors/failures.dart';
import 'package:electricity/common/utils/utils.dart';
import 'package:electricity/domain/entities/entities.dart';
import 'package:electricity/domain/usecases/place_usecase.dart';
import 'package:electricity/domain/usecases/price_usecase.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PriceUsecase priceUsecase;
  final PlaceUsecase placeUsecase;

  final List<GeoId> geoIds = Utils.getGeoIds();

  DateTime date = DateTime.now();
  GeoId? geoId;
  late Value minValue;
  late Value maxValue;
  late Value? currentValue;
  late double averageValue;

  HomeBloc({required this.priceUsecase, required this.placeUsecase})
      : super(const PricesLoadingState()) {
    on<LoadingPriceEvent>(
      (event, emit) async {
        emit(const PricesLoadingState());

        // await Future.delayed(const Duration(seconds: 1));

        //geoId
        if (geoId == null) {
          final geo = await _getPlace();
          geo.fold(
            (failure) => geoId = geoIds[0],
            (geo) => geoId = geo,
          );
        }

        final prices = await _getPrices();
        prices.fold(
          (failure) => emit(const PricesErrorState()),
          (prices) {
            averageValue = _getAveragePrice(prices.included.attributes.values);

            Value valueMax = _getValueMax(prices.included.attributes.values);
            maxValue = valueMax;

            Value valueMin = _getValueMin(prices.included.attributes.values);
            minValue = valueMin;

            currentValue = _getCurrentValue(prices.included.attributes.values);

            emit(PricesLoadedState(prices: prices));
          },
        );
      },
    );
  }

  Future<Either<Failure, GeoId>> _getPlace() async {
    final response = await placeUsecase.call(null);
    return response;
  }

  Future<Either<Failure, Prices>> _getPrices() async {
    date = DateTime(date.year, date.month, date.day);
    String startDate = date.toIso8601String();
    String endDate =
        date.add(const Duration(hours: 23, minutes: 59)).toIso8601String();
    PricesParams params = PricesParams(
      startDate,
      endDate,
      geoId!,
    );
    final response = await priceUsecase.call(params);
    return response;
  }

  IntervalEnum getInterval(List<Value> values, Value currentValue) {
    double valueMin = minValue.value;
    double valueMax = maxValue.value;
    double interval = (valueMax - valueMin) / 3; //three parts
    if ((valueMin + interval) > currentValue.value) {
      return IntervalEnum.interval1;
    } else if ((valueMax - interval) < currentValue.value) {
      return IntervalEnum.interval3;
    } else {
      return IntervalEnum.interval2;
    }
  }

  Value _getValueMax(List<Value> values) {
    Value valueMax = values[0];

    for (Value item in values) {
      if (item.value > valueMax.value) {
        valueMax = item;
      }
    }
    return valueMax;
  }

  Value _getValueMin(List<Value> values) {
    Value valueMin = values[0];

    for (Value item in values) {
      if (item.value < valueMin.value) {
        valueMin = item;
      }
    }
    return valueMin;
  }

  double _getAveragePrice(List<Value> values) {
    double average = 0;
    for (Value item in values) {
      average += item.value;
    }
    return average / values.length / 1000; //KWh
  }

  Value? _getCurrentValue(List<Value> values) {
    Value? value;
    for (Value item in values) {
      if (item.datetime.day == DateTime.now().day &&
          item.datetime.month == DateTime.now().month &&
          item.datetime.year == DateTime.now().year &&
          item.datetime.hour < DateTime.now().hour + 1 &&
          item.datetime.hour >= DateTime.now().hour) {
        value = item;
      }
    }
    return value;
  }

  bool isValueMax(Value value) {
    return value == maxValue;
  }

  bool isValueMin(Value value) {
    return value == minValue;
  }

  bool isValueNow(Value value) {
    return value == currentValue;
  }
}
