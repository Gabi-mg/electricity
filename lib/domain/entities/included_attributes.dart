import 'package:electricity/domain/entities/value.dart';

class IncludedAttributes {
  final String title;
  final DateTime lastUpdate;
  final List<Value> values;

  IncludedAttributes({
    required this.title,
    required this.lastUpdate,
    required this.values,
  });
}
