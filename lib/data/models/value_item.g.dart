// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValueItem _$ValueItemFromJson(Map<String, dynamic> json) => ValueItem(
      value: (json['value'] as num).toDouble(),
      datetime: json['datetime'] as String,
    );

Map<String, dynamic> _$ValueItemToJson(ValueItem instance) => <String, dynamic>{
      'value': instance.value,
      'datetime': instance.datetime,
    };
