import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app/locator.dart';
import '../../models/user.dart';
import '../rest_service.dart';

class UserRestService {
  final RestService _rest = locator<RestService>();

  Future<User> getUser(String id) async {
    final json = await _rest.get('user/$id');
    return User.fromJson(json);
  }

  Future<List<User>> getUsers() async {
    final jsonList = await _rest.get('user/all');
    if (jsonList is List)
      return jsonList.map((json) => User.fromJson(json)).toList();
    return [];
  }

  Future<List<User>> getCompanionsForUser(String id) async {
    final jsonList = await _rest.get('user/$id/companions');
    if (jsonList is List)
      return jsonList.map((json) => User.fromJson(json)).toList();
    return [];
  }

  Future<List<User>> getCompanionsForCommunity(String id) async {
    final jsonList = await _rest.get('community/$id/companions');
    if (jsonList is List)
      return jsonList.map((json) => User.fromJson(json)).toList();
    return [];
  }

  Future<List<User>> getAdminsForCommunity(String id) async {
    final jsonList = await _rest.get('community/$id/admins');
    if (jsonList is List)
      return jsonList.map((json) => User.fromJson(json)).toList();
    return [];
  }

  Future createUser(User user) async {
    final json = await _rest.post('user', data: user.toJson());
    return User.fromJson(json);
  }

  Future updateUser(
    String id, {
    String email,
    String username,
    String displayName,
    String phoneNumber,
    String photoUrl,
    String photoHeaderUrl,
    String description,
    int awardCount,
    List<String> tags,
    List<String> posts,
    List<String> companions,
    List<String> communities,
    List<String> chatDirects,
    List<String> chatRooms,
    Map<String, dynamic> settings,
    GeoPoint location,
  }) async {
    Map<String, dynamic> data = Map();
    ({
      'email': email,
      'phoneNumber': phoneNumber,
      'username': username,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'photoHeaderUrl': photoHeaderUrl,
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
    }).forEach((key, value) {
      if (value != null) data[key] = value;
    });

    final json = await _rest.patch('user/$id', data: data);
    return User.fromJson(json);
  }

  Future deleteUser(String id) async {
    await _rest.delete('user/$id');
  }
}
