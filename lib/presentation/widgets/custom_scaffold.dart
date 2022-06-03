import 'package:electricity/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precio de la luz por horas '),
        actions: [
          IconButton(
            onPressed: () {
              displayDialogSearch(context);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: body,
    );
  }

  void displayDialogSearch(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return const SearchDialog();
      },
    );
  }
}
