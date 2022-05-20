// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'included_attributes_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncludedAttributesItem _$IncludedAttributesItemFromJson(
        Map<String, dynamic> json) =>
    IncludedAttributesItem(
      title: json['title'] as String,
      lastUpdate: DateTime.parse(json['last-update'] as String),
      values: (json['values'] as List<dynamic>)
          .map((e) => ValueItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IncludedAttributesItemToJson(
        IncludedAttributesItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'last-update': instance.lastUpdate.toIso8601String(),
      'values': instance.values,
    };
