import 'package:electricity/domain/entities/geo_id.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDropdownWidget extends StatefulWidget {
  const CustomDropdownWidget({
    Key? key,
    required this.geoIds,
  }) : super(key: key);

  final List<GeoId> geoIds;

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<HomeBloc>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
      child: DropdownButtonFormField<GeoId>(
        icon: Icon(
          Icons.place,
          color: Theme.of(context).primaryColor,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        value: blocProvider.geoId,
        items: widget.geoIds.map((geoId) {
          return DropdownMenuItem<GeoId>(
            value: geoId,
            child: Text(geoId.description),
          );
        }).toList(),
        onChanged: (geoId) {
          blocProvider.geoId = geoId!;
          blocProvider.add(const LoadingEvent());
          setState(() {});
        },
      ),
    );
  }
}
