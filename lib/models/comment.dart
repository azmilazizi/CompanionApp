import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/datetime_timestamp_util.dart';

class Comment {
  String id;
  String postId;
  String authorId;
  String body;
  List<String> upvotes;
  List<String> comments;
  List<String> awards;
  DateTime createdAt;

  Comment({
    this.id,
    this.postId,
    this.authorId,
    this.body,
    this.upvotes,
    this.comments,
    this.awards,
    this.createdAt,
  });

  factory Comment.createNew({
    String id,
    String postId,
    String authorId,
    String title,
    String body,
    String mediaUrl,
    String mediaType,
  }) =>
      Comment(
        id: id,
        postId: postId,
        authorId: authorId,
        body: body,
        upvotes: [],
        comments: [],
        awards: [],
        createdAt: DateTime.now(),
      );

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data();
    json['id'] = snapshot.id;
    return Comment.fromJson(json);
  }

  factory Comment.fromRawJson(String str) => Comment.fromJson(jsonDecode(str));

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        postId: json['postId'],
        authorId: json['authorId'],
        body: json['body'],
        upvotes: List<String>.from(json['upvotes']),
        comments: List<String>.from(json['comments']),
        awards: List<String>.from(json['awards']),
        createdAt: dateTimeFromTimestamp(json['createdAt']),
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'authorId': authorId,
        'body': body,
        'upvotes': upvotes,
        'comments': comments,
        'awards': awards,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
