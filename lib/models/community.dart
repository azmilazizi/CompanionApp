import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/datetime_timestamp_util.dart';

class Community {
  String id;
  String name;
  String photoUrl;
  String headerPhotoUrl;
  String description;
  List<String> tags;
  List<String> posts;
  List<String> companions;
  List<String> admins;
  DateTime createdAt;

  Community({
    this.id,
    this.name,
    this.photoUrl,
    this.headerPhotoUrl,
    this.description,
    this.tags,
    this.posts,
    this.companions,
    this.admins,
    this.createdAt,
  });

  factory Community.createNew({
    String id,
    String name,
    String description,
    String firstUser,
  }) =>
      Community(
        id: id,
        name: name,
        photoUrl: '',
        headerPhotoUrl: '',
        description: description,
        tags: [],
        posts: [],
        companions: [firstUser],
        admins: [firstUser],
        createdAt: DateTime.now(),
      );

  factory Community.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data();
    json['id'] = snapshot.id;
    return Community.fromJson(json);
  }

  factory Community.fromRawJson(String str) =>
      Community.fromJson(json.decode(str));

  factory Community.fromJson(Map<String, dynamic> json) => Community(
        id: json['id'],
        name: json['name'],
        photoUrl: json['photoUrl'],
        headerPhotoUrl: json['headerPhotoUrl'],
        description: json['description'],
        tags: List<String>.from(json['tags']),
        posts: List<String>.from(json['posts']),
        companions: List<String>.from(json['companions']),
        admins: List<String>.from(json['admins']),
        createdAt: dateTimeFromTimestamp(json['createdAt']),
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'name': name,
        'photoUrl': photoUrl,
        'headerPhotoUrl': headerPhotoUrl,
        'description': description,
        'tags': tags,
        'posts': posts,
        'companions': companions,
        'admins': admins,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
