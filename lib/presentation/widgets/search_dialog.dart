import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:electricity/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      title: const Text('Elija criterios de búsqueda'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CustomDropdown(),
          CustomDatepicker(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final priceBlocProvider = BlocProvider.of<HomeBloc>(
              context,
              listen: false,
            );
            priceBlocProvider.add(const LoadingPriceEvent());
            Navigator.pop(context);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
