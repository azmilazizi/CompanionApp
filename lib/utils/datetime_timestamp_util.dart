import 'package:cloud_firestore/cloud_firestore.dart';

DateTime dateTimeFromTimestamp(dynamic val) {
  Timestamp timestamp;
  if (val is Timestamp) {
    timestamp = val;
  } else if (val is Map) {
    timestamp = Timestamp(val['_seconds'], val['_nanoseconds']);
  }
  if (timestamp != null) {
    return timestamp.toDate();
  } else {
    print('Unable to parse Timestamp from $val');
    return null;
  }
}
