import 'package:electricity/domain/entities/geo_id.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDropdownWidget extends StatelessWidget {
  const CustomDropdownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<HomeBloc>(context);
    List<GeoId> geoIds = [];
    GeoId geoId = GeoId(geoId: "8741", description: "Peninsula");
    geoIds.add(geoId);
    blocProvider.geoId = geoId;
    geoId = GeoId(geoId: "8742", description: "Canarias");
    geoIds.add(geoId);
    geoId = GeoId(geoId: "8743", description: "Baleares");
    geoIds.add(geoId);
    geoId = GeoId(geoId: "8744", description: "Ceuta");
    geoIds.add(geoId);
    geoId = GeoId(geoId: "8745", description: "Melilla");
    geoIds.add(geoId);
    return DropdownButton<GeoId>(
      value: blocProvider.geoId,
      items: geoIds.map((geoId) {
        return DropdownMenuItem<GeoId>(
          value: geoId,
          child: Text(geoId.description),
        );
      }).toList(),
      onChanged: (geoId) {
        blocProvider.geoId = geoId!;
      },
    );
  }
}
