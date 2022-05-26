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
  late double valueMin;
  late double valueMax;

  final _averageStateController = StreamController<double>();
  final _valueMaxStateController = StreamController<Value>();
  final _valueMinStateController = StreamController<Value>();
  final _valueCurrentStateController = StreamController<Value>();

  Sink<double> get inAverage => _averageStateController.sink;

  Stream<double> get outAverage => _averageStateController.stream;

  Sink<Value> get inValueMax => _valueMaxStateController.sink;

  Stream<Value> get outValueMax => _valueMaxStateController.stream;

  Sink<Value> get inValueMin => _valueMinStateController.sink;

  Stream<Value> get outValueMin => _valueMinStateController.stream;

  Sink<Value> get inValueCurrent => _valueCurrentStateController.sink;

  Stream<Value> get outValueCurrent => _valueCurrentStateController.stream;

  HomeBloc({required this.priceUsecase, required this.placeUsecase})
      : super(const PricesLoadingState()) {
    on<LoadingPriceEvent>(
      (event, emit) async {
        emit(const PricesLoadingState());

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
            double average =
                _getAveragePrice(prices.included.attributes.values);
            inAverage.add(average);

            Value valueMax = _getValueMax(prices.included.attributes.values);
            inValueMax.add(valueMax);
            this.valueMax = valueMax.value;

            Value valueMin = _getValueMin(prices.included.attributes.values);
            inValueMin.add(valueMin);
            this.valueMin = valueMin.value;

            Value currentValue =
                _getCurrentValue(prices.included.attributes.values);
            inValueCurrent.add(currentValue);

            emit(PricesLoadedState(prices: prices));
          },
        );
      },
    );
  }

  void dispose() {
    _averageStateController.close();
    _valueMaxStateController.close();
    _valueMinStateController.close();
    _valueCurrentStateController.close();
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

  Value _getCurrentValue(List<Value> values) {
    Value value = values[0];
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
