import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/datetime_timestamp_util.dart';

class Message {
  String id;
  String author;
  String body;
  String mediaUrl;
  bool like;
  DateTime createdAt;

  Message({
    this.id,
    this.author,
    this.body,
    this.mediaUrl,
    this.like,
    this.createdAt,
  });

  factory Message.createNew({
    String id,
    String author,
    String body,
    String mediaUrl,
  }) =>
      Message(
        id: id,
        author: author,
        body: body,
        mediaUrl: mediaUrl,
        like: false,
        createdAt: DateTime.now(),
      );

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data();
    json['id'] = snapshot.id;
    return Message.fromJson(json);
  }

  factory Message.fromRawJson(String str) => Message.fromJson(jsonDecode(str));

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        author: json['author'],
        body: json['body'],
        mediaUrl: json['mediaUrl'],
        like: json['like'],
        createdAt: dateTimeFromTimestamp(json['createdAt']),
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'author': author,
        'body': body,
        'mediaUrl': mediaUrl,
        'like': like,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
