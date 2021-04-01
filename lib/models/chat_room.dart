import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/datetime_timestamp_util.dart';

import 'message.dart';

class ChatRoom {
  String id;
  String name;
  String description;
  int userCount;
  List<String> users;
  List<String> admins;
  List<Message> logs;
  DateTime createdAt;
  DateTime lastUpdated;

  ChatRoom({
    this.id,
    this.name,
    this.description,
    this.userCount,
    this.users,
    this.admins,
    this.logs,
    this.createdAt,
    this.lastUpdated,
  });

  factory ChatRoom.createNew({
    String id,
    String name,
    String firstUser,
    List<String> users,
  }) =>
      ChatRoom(
        id: id,
        name: name,
        description: '',
        userCount: 0,
        users: users,
        admins: [firstUser],
        logs: [],
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

  factory ChatRoom.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data();
    json['id'] = snapshot.id;
    return ChatRoom.fromJson(json);
  }

  factory ChatRoom.fromRawJson(String str) =>
      ChatRoom.fromJson(jsonDecode(str));

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        userCount: json['userCount'],
        users: List<String>.from(json['users']),
        admins: List<String>.from(json['admins']),
        logs: List<Message>.from(
            json['logs'].map((e) => Message.fromJson(e)).toList()),
        createdAt: dateTimeFromTimestamp(json['createdAt']),
        lastUpdated: dateTimeFromTimestamp(json['lastUpdated']),
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'userCount': userCount,
        'users': users,
        'admins': admins,
        'logs': logs.map((e) => e.toJson()).toList(),
        'createdAt': Timestamp.fromDate(createdAt),
        'lastUpdated': Timestamp.fromDate(lastUpdated),
      };
}
