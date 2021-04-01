import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companion/utils/datetime_timestamp_util.dart';

import './message.dart';

class ChatDirect {
  String id;
  List<String> users;
  List<Message> logs;
  DateTime lastUpdated;

  ChatDirect({
    this.id,
    this.users,
    this.logs,
    this.lastUpdated,
  });

  factory ChatDirect.createNew({
    String id,
    List<String> users,
  }) =>
      ChatDirect(
        id: id,
        users: users,
        logs: [],
        lastUpdated: DateTime.now(),
      );

  factory ChatDirect.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data();
    json['id'] = snapshot.id;
    return ChatDirect.fromJson(json);
  }

  factory ChatDirect.fromRawJson(String str) =>
      ChatDirect.fromJson(jsonDecode(str));

  factory ChatDirect.fromJson(Map<String, dynamic> json) => ChatDirect(
        id: json['id'],
        users: List<String>.from(json['users']),
        logs: List<Message>.from(
            json['logs'].map((e) => Message.fromJson(e)).toList()),
        lastUpdated: dateTimeFromTimestamp(json['lastUpdated']),
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'users': users,
        'logs': logs.map((e) => e.toJson()).toList(),
        'lastUpdated': Timestamp.fromDate(lastUpdated),
      };
}
