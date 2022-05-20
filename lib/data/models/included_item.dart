import 'package:electricity/data/models/included_attributes_item.dart';
import 'package:json_annotation/json_annotation.dart';
part 'included_item.g.dart';

@JsonSerializable()
class IncludedItem {
  @JsonKey(name: 'attributes')
  IncludedAttributesItem attributes;

  IncludedItem({
    required this.attributes,
  });

  factory IncludedItem.fromJson(Map<String, dynamic> json) =>
      _$IncludedItemFromJson(json);

  Map<String, dynamic> toJson() => _$IncludedItemToJson(this);
}
