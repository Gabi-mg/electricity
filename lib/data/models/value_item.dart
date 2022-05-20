import 'package:json_annotation/json_annotation.dart';

part 'value_item.g.dart';

@JsonSerializable()
class ValueItem {
  double value;
  String datetime;

  ValueItem({
    required this.value,
    required this.datetime,
  });

  factory ValueItem.fromJson(Map<String, dynamic> json) =>
      _$ValueItemFromJson(json);

  Map<String, dynamic> toJson() => _$ValueItemToJson(this);
}
