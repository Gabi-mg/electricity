import 'package:electricity/domain/entities/geo_id.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDropdownWidget extends StatefulWidget {
  const CustomDropdownWidget({Key? key}) : super(key: key);

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    final priceBlocProvider = BlocProvider.of<HomeBloc>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: DropdownButtonFormField<GeoId>(
        icon: Icon(
          Icons.place,
          color: Theme.of(context).primaryColor,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
        ),
        value: priceBlocProvider.geoId,
        items: priceBlocProvider.geoIds.map((geoId) {
          return DropdownMenuItem<GeoId>(
            value: geoId,
            child: Text(geoId.description),
          );
        }).toList(),
        onChanged: (geoId) {
          priceBlocProvider.geoId = geoId!;
          setState(() {});
        },
      ),
    );
  }
}
