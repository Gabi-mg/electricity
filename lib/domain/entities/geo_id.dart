import 'package:equatable/equatable.dart';

class GeoId extends Equatable{
  String geoId;
  String description;

  GeoId({
    required this.geoId,
    required this.description,
  });

  factory GeoId.fromJson(Map<String, dynamic> json) => GeoId(
        geoId: json["geoId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "geoId": geoId,
        "description": description,
      };

  @override
  List<Object?> get props => [geoId, description];
}
