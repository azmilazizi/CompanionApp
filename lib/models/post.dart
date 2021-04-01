import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/datetime_timestamp_util.dart';

class Post {
  String id;
  String authorId;
  String communityId;
  String title;
  String body;
  String mediaUrl;
  String mediaType;
  List<String> upvotes;
  List<String> tags;
  List<String> comments;
  List<String> awards;
  DateTime createdAt;

  Post({
    this.id,
    this.authorId,
    this.communityId,
    this.title,
    this.body,
    this.mediaUrl,
    this.mediaType,
    this.upvotes,
    this.tags,
    this.comments,
    this.awards,
    this.createdAt,
  });

  factory Post.createNew({
    String id,
    String authorId,
    String communityId,
    String title,
    String body,
    String mediaUrl,
    String mediaType,
  }) =>
      Post(
        id: id,
        authorId: authorId,
        communityId: communityId,
        title: title,
        body: body,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        upvotes: [],
        tags: [],
        comments: [],
        awards: [],
        createdAt: DateTime.now(),
      );

  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data();
    json['id'] = snapshot.id;
    return Post.fromJson(json);
  }

  factory Post.fromRawJson(String str) => Post.fromJson(jsonDecode(str));

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        authorId: json['authorId'],
        communityId: json['communityId'],
        title: json['title'],
        body: json['body'],
        mediaUrl: json['mediaUrl'],
        mediaType: json['mediaType'],
        upvotes: List<String>.from(json['upvotes']),
        tags: List<String>.from(json['tags']),
        comments: List<String>.from(json['comments']),
        awards: List<String>.from(json['awards']),
        createdAt: dateTimeFromTimestamp(json['createdAt']),
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'communityId': communityId,
        'title': title,
        'body': body,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'upvotes': upvotes,
        'tags': tags,
        'comments': comments,
        'awards': awards,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
