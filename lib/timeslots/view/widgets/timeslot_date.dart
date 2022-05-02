import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSlotDate extends StatefulWidget {
  const TimeSlotDate({
    Key? key,
    required this.initialDate,
  }) : super(key: key);

  final DateTime initialDate;

  @override
  State<TimeSlotDate> createState() => _TimeSlotDateState();
}

class _TimeSlotDateState extends State<TimeSlotDate> {
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          /// TODO update the date time for the cubit
          setState(() {
            _dateTime = date!;
          });
        },
        child: Text(
          DateFormat.yMMMMEEEEd().format(_dateTime),
          style: const TextStyle(fontSize: 14),
        ),),
    );
  }
}
