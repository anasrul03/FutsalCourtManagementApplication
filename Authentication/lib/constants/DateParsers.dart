import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateParser {
  static String parseDateTimeyMdAddJM(Timestamp timestamp) {
    DateTime parsedTimeStamp = timestamp.toDate();
    return DateFormat.yMd().add_jm().format(parsedTimeStamp);
  }

  static String parseDateTimeyMMMMd(Timestamp timestamp) {
    DateTime parsedTimeStamp = timestamp.toDate();
    return DateFormat.yMMMMd('en_US').format(parsedTimeStamp);
  }

  static String parseDateTimeaddJM(Timestamp timestamp) {
    DateTime parsedTimeStamp = timestamp.toDate();
    return DateFormat.jm().format(parsedTimeStamp);
  }

  static String parseDateTimeyMdaddJM(Timestamp timestamp) {
    DateTime parsedTimeStamp = timestamp.toDate();
    return DateFormat.yMd().add_jm().format(parsedTimeStamp);
  }
}
