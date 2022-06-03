import 'package:electricity/common/utils/constants.dart';
import 'package:electricity/common/utils/utils.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDatepicker extends StatelessWidget {
  const CustomDatepicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<HomeBloc>(context, listen: false);
    final controller = TextEditingController();
    controller.text = Utils.formatDate(blocProvider.date);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        autofocus: false,
        readOnly: true,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime lastDate;
          if (DateTime.now().hour >= hourOpenApi) {
            lastDate = DateTime.now().add(const Duration(days: 1));
          } else {
            lastDate = DateTime.now();
          }

          final DateTime? selected = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(firsDate),
            lastDate: lastDate,
          );

          if (selected != null) {
            controller.text = Utils.formatDate(selected);
            blocProvider.date = selected;
          }
        },
      ),
    );
  }
}
