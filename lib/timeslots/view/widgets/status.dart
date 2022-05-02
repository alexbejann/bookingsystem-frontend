
import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  const Status({
    Key? key, required this.isReserved,
  }) : super(key: key);

  final bool isReserved;

  @override
  Widget build(BuildContext context) {
    return Text(
      isReserved ? 'Reserved' : 'Available',
      style: TextStyle(color: isReserved ? Colors.red : Colors.green),
    );
  }
}
