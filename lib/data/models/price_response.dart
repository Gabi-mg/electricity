import 'package:electricity/data/models/included_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'price_response.g.dart';

@JsonSerializable()
class PriceResponse {
  @JsonKey(name: 'included')
  List<IncludedItem> included;

  PriceResponse({
    required this.included,
  });

  factory PriceResponse.fromJson(Map<String, dynamic> json) =>
      _$PriceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PriceResponseToJson(this);
}
