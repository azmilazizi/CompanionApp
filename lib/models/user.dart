import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/datetime_timestamp_util.dart';

class User {
  String id;
  String email;
  String username;
  String displayName;
  String phoneNumber;
  String photoUrl;
  String headerPhotoUrl;
  String description;
  int awardCount;
  List<String> tags;
  List<String> posts;
  List<String> companions;
  List<String> communities;
  List<String> chatDirects;
  List<String> chatRooms;
  Map<String, dynamic> settings;
  Map<String, dynamic> location;
  DateTime createdAt;

  User({
    this.id,
    this.email,
    this.username,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.headerPhotoUrl,
    this.description,
    this.awardCount,
    this.location,
    this.tags,
    this.posts,
    this.companions,
    this.communities,
    this.chatDirects,
    this.chatRooms,
    this.settings,
    this.createdAt,
  });

  factory User.createNew({
    String id,
    String email,
    String username,
    String displayName,
  }) =>
      User(
        id: id,
        email: email,
        username: username,
        displayName: displayName,
        phoneNumber: '',
        photoUrl: '',
        headerPhotoUrl: '',
        description: '',
        awardCount: 0,
        tags: [],
        posts: [],
        companions: [],
        communities: [],
        chatDirects: [],
        chatRooms: [],
        settings: {},
        location: null,
        createdAt: DateTime.now(),
      );

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data();
    json['id'] = snapshot.id;
    return User.fromJson(json);
  }

  factory User.fromRawJson(String str) => User.fromJson(jsonDecode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        displayName: json['displayName'],
        phoneNumber: json['phoneNumber'],
        photoUrl: json['photoUrl'],
        headerPhotoUrl: json['headerPhotoUrl'],
        description: json['description'],
        awardCount: json['awardCount'],
        tags: List<String>.from(json['tags']),
        posts: List<String>.from(json['posts']),
        companions: List<String>.from(json['companions']),
        communities: List<String>.from(json['communities']),
        chatDirects: List<String>.from(json['chatDirects']),
        chatRooms: List<String>.from(json['chatRooms']),
        settings: json['settings'],
        location: json['location'],
        createdAt: dateTimeFromTimestamp(json['createdAt']),
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'photoUrl': photoUrl,
        'headerPhotoUrl': headerPhotoUrl,
        'description': description,
        'awardCount': awardCount,
        'tags': tags,
        'posts': posts,
        'companions': companions,
        'communities': communities,
        'chatDirects': chatDirects,
        'chatRooms': chatRooms,
        'settings': settings,
        'location': location,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
