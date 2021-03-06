import 'package:electricity/common/utils/constants.dart';
import 'package:electricity/common/utils/utils.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputDatepickerWidget extends StatelessWidget {
  const InputDatepickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<HomeBloc>(context);
    final controller = TextEditingController();
    controller.text = Utils.formatDate(DateTime.now());

    return TextField(
      textAlign: TextAlign.center,
      controller: controller,
      autofocus: false,
      readOnly: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      onTap: () async {
        DateTime lastDate;
        if (DateTime.now().hour > hourOpenApi) {
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
          blocProvider.add(LoadingEvent(date: selected));
        }
      },
    );
  }
}
