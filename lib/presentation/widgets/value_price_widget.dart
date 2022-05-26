import 'package:flutter/material.dart';

class ValuePriceWidget extends StatelessWidget {
  const ValuePriceWidget({
    Key? key,
    required this.title,
    required this.price,
    required this.color,
    this.hour,
  }) : super(key: key);

  final String title;
  final String? hour;
  final String price;
  final Color color;

  //TODO check style
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          const SizedBox(
            height: 10,
          ),
          if (hour != null)
            Text(
              hour!,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          Text(
            '$price€',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          )
        ],
      ),
      width: 120,
      height: 100,
    );
  }
}
