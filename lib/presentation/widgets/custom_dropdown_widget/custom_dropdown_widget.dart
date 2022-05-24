import 'package:electricity/domain/entities/geo_id.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:electricity/presentation/widgets/custom_dropdown_widget/bloc/place_bloc.dart';
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
    final placeBlocProvider =
        BlocProvider.of<PlaceBloc>(context, listen: false);

    return BlocBuilder<PlaceBloc, PlaceState>(
      builder: (context, state) {
        if (state is PlaceLoadedState) {
          final geoId = state.geoId;
          priceBlocProvider.geoId = geoId;
          priceBlocProvider.add(const LoadingPriceEvent());
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
              value: geoId,
              items: placeBlocProvider.geoIds.map((geoId) {
                return DropdownMenuItem<GeoId>(
                  value: geoId,
                  child: Text(geoId.description),
                );
              }).toList(),
              onChanged: (geoId) {
                priceBlocProvider.geoId = geoId!;
                priceBlocProvider.add(const LoadingPriceEvent());

                setState(() {});
              },
            ),
          );
        } else {
          return const CircularProgressIndicator.adaptive(
            strokeWidth: 6.0,
          );
        }
      },
    );
  }
}
