import 'package:electricity/common/utils/utils.dart';
import 'package:electricity/domain/entities/interval_enum.dart';
import 'package:flutter/material.dart';

class Value {
  final double value;
  final DateTime datetime;

  Value({
    required this.value,
    required this.datetime,
  });

  String get hour {
    int hour = datetime.hour;
    final hourStart = Utils.formatNumber0Left(hour, 2);
    final hourEnd = Utils.formatNumber0Left(hour + 1, 2);

    return '${hourStart}h - ${hourEnd}h';
  }

  String get valueKWh {
    return (value / 1000).toStringAsFixed(5);
  }

  Color getColor(IntervalEnum interval) {
    switch (interval) {
      case IntervalEnum.interval1:
        return Colors.green;
      case IntervalEnum.interval2:
        return Colors.orange;
      case IntervalEnum.interval3:
        return Colors.red;
    }
  }
}
