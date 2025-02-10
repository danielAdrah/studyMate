import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();
  String hour = dateTime.hour.toString();
  String minute = dateTime.minute.toString();

  String formatDate = '$day/$month/$year\n $hour:$minute';
  return formatDate;
}
