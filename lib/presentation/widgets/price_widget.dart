import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  final String value;
  final String time;
  final Color color;
  final bool isHighestPrice;
  final bool isLowestPrice;
  final bool isCurrentValue;

  final double _fontSize = 16;

  const PriceWidget({
    Key? key,
    required this.value,
    required this.time,
    required this.color,
    this.isHighestPrice = false,
    this.isLowestPrice = false,
    this.isCurrentValue = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getContainer(),
        _getTextTime(),
        _getTextPrice(),
        if (isHighestPrice)
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.trending_up,
              size: 20,
              color: color,
            ),
          ),
        if (isLowestPrice)
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.trending_down,
              size: 18,
              color: color,
            ),
          ),
      ],
    );
  }

  Container _getContainer() {
    if (isCurrentValue) {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
      );
    }
  }

  Text _getTextTime() {
    if (isCurrentValue) {
      return Text(
        '$time: ',
        style: TextStyle(
            color: Colors.black87,
            fontSize: _fontSize,
            fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        '$time: ',
        style: const TextStyle(
          color: Colors.black87,
        ),
      );
    }
  }

  Text _getTextPrice() {
    if (isCurrentValue) {
      return Text(
        '$value €/KWh',
        style: TextStyle(
          color: color,
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        '$value €/KWh',
        style: TextStyle(
          color: color,
        ),
      );
    }
  }
}
