// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DateTimeSelector extends StatelessWidget {
  const DateTimeSelector(
      {super.key,
      required this.selectedDate,
      required this.selectedTime,
      required this.onDateTimeChanged});
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function(DateTime, TimeOfDay) onDateTimeChanged;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (picked != null && picked != selectedDate) {
      onDateTimeChanged(picked, selectedTime);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      onDateTimeChanged(selectedDate, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              selectDate(context);
            },
            label: Text(
                'Date : ${selectedDate.toLocal().toString().split(' ')[0]}'),
            icon: Icon(Icons.calendar_month_outlined),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              selectTime(context);
            },
            label: Text('Time : ${selectedTime.format(context)}'),
            icon: Icon(Icons.calendar_month_outlined),
          ),
        ),
      ],
    );
  }
}
