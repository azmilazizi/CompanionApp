import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';

class UserFirestoreService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<User> getUser(String id) async {
    DocumentSnapshot snapshot = await _usersRef.doc(id).get();
    return User.fromSnapshot(snapshot);
  }

  Future<List<User>> getUsers() async {
    QuerySnapshot snapshots = await _usersRef.get();
    return snapshots.docs
        .map((snapshot) => User.fromSnapshot(snapshot))
        .toList();
  }

  Future<List<User>> getUsersFromIds(List<String> ids) async {
    QuerySnapshot snapshots =
        await _usersRef.where(FieldPath.documentId, whereIn: ids).get();
    return snapshots.docs.map((snapshot) {
      return User.fromSnapshot(snapshot);
    }).toList();
  }
  
  Future createUser(User user) async {
    return _usersRef.doc(user.id).set(user.toJson());
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
    Map<String, dynamic> location,
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

    return _usersRef.doc(id).update(data);
  }

  Future deleteUser(String id) async {
    await _usersRef.doc(id).delete();
  }
}
