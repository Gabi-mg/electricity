import 'package:electricity/data/models/price_response.dart';
import 'package:electricity/domain/entities/included.dart';
import 'package:electricity/domain/entities/included_attributes.dart';
import 'package:electricity/domain/entities/prices.dart';
import 'package:electricity/domain/entities/value.dart';

class Mapper {
  static Prices transformPricesResponse(PriceResponse priceResponse) {
    final List<Value> values = [];
    for (var element in priceResponse.included[0].attributes.values) {
      DateTime dateTime = DateTime.parse(element.datetime.split('+')[0]);

      Value value = Value(
        value: element.value,
        datetime: dateTime,
      );

      values.add(value);
    }

    final IncludedAttributes includedAttributes = IncludedAttributes(
      title: priceResponse.included[0].attributes.title,
      lastUpdate: priceResponse.included[0].attributes.lastUpdate,
      values: values,
    );

    final Included included = Included(attributes: includedAttributes);

    final Prices prices = Prices(included: included);

    return prices;
  }
}
