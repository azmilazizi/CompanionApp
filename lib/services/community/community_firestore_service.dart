import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/community.dart';

class CommunityFirestoreService {
  final CollectionReference _communitiesRef =
      FirebaseFirestore.instance.collection('communities');

  Future<Community> getCommunity(String id) async {
    DocumentSnapshot snapshot = await _communitiesRef.doc(id).get();
    return Community.fromSnapshot(snapshot);
  }

  Future<List<Community>> getCommunities() async {
    QuerySnapshot snapshots = await _communitiesRef.get();
    return snapshots.docs
        .map((snapshot) => Community.fromSnapshot(snapshot))
        .toList();
  }

  Future<List<Community>> getCommunitiesFromIds(List<String> ids) async {
    QuerySnapshot snapshots =
        await _communitiesRef.where(FieldPath.documentId, whereIn: ids).get();
    return snapshots.docs.map((snapshot) {
      return Community.fromSnapshot(snapshot);
    }).toList();
  }

  Future createCommunity(Community community) async {
    return _communitiesRef.add(community.toJson());
  }

  Future updateCommunity(
   String id, {
    String photoUrl,
    String headerPhotoUrl,
    String description,
    List<String> tags,
    List<String> posts,
    List<String> companions,
    List<String> admins,
  }) async {
    Map<String, dynamic> data = Map();
    ({
     'photoUrl': photoUrl,
      'headerPhotoUrl': headerPhotoUrl,
      'description': description,
      'tags': tags,
      'posts': posts,
      'companions': companions,
      'admins': admins,
    }).forEach((key, value) {
      if (value != null) data[key] = value;
    });

    return _communitiesRef.doc(id).update(data);
  }

  Future deleteCommunity(String id) async {
    await _communitiesRef.doc(id).delete();
  }
}
