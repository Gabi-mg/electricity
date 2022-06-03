import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  const CustomError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromRGBO(247, 247, 247, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            width: 300.0,
            height: 300.0,
            image: AssetImage('assets/error.png'),
          ),
          Text('¡¡¡Upss!!! Hubo un error. Inténtelo más tarde'),
        ],
      ),
    );
  }
}
