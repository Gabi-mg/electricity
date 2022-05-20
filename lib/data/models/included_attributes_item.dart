import 'package:electricity/data/models/value_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'included_attributes_item.g.dart';

@JsonSerializable()
class IncludedAttributesItem {
  String title;

  @JsonKey(name: 'last-update')
  DateTime lastUpdate;

  List<ValueItem> values;

  IncludedAttributesItem({
    required this.title,
    required this.lastUpdate,
    required this.values,
  });

  factory IncludedAttributesItem.fromJson(Map<String, dynamic> json) =>
      _$IncludedAttributesItemFromJson(json);

  Map<String, dynamic> toJson() => _$IncludedAttributesItemToJson(this);
}
