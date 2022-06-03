import 'package:flutter/material.dart';

class HourDetail extends StatelessWidget {
  final String value;
  final String time;
  final Color color;
  final bool isHighestPrice;
  final bool isLowestPrice;
  final bool isCurrentValue;

  const HourDetail({
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      color: _getColorBackground(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getContainer(),
          _getTextTime(),
          _getTextPrice(),
        ],
      ),
    );
  }

  Container _getContainer() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
    );
  }

  Text _getTextTime() {
    return Text(
      '$time: ',
      style: const TextStyle(
        color: Colors.black87,
      ),
    );
  }

  Text _getTextPrice() {
    return Text(
      '$value €/KWh',
      style: TextStyle(
        color: color,
      ),
    );
  }

  Color _getColorBackground() {
    if (isHighestPrice) {
      return Colors.red[100]!;
    } else if (isLowestPrice) {
      return Colors.green[100]!;
    } else if (isCurrentValue) {
      return Colors.grey[200]!;
    } else {
      return Colors.white;
    }
  }
}
