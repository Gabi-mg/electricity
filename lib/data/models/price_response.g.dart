// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceResponse _$PriceResponseFromJson(Map<String, dynamic> json) =>
    PriceResponse(
      included: (json['included'] as List<dynamic>)
          .map((e) => IncludedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PriceResponseToJson(PriceResponse instance) =>
    <String, dynamic>{
      'included': instance.included,
    };
