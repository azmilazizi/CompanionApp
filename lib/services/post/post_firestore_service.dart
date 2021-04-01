import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/post.dart';

class PostFirestoreService {
  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');

  Future<Post> getPost(String id) async {
    DocumentSnapshot snapshot = await _postsRef.doc(id).get();
    return Post.fromSnapshot(snapshot);
  }

  Future<List<Post>> getPosts() async {
    QuerySnapshot snapshots = await _postsRef.get();
    return snapshots.docs
        .map((snapshot) => Post.fromSnapshot(snapshot))
        .toList();
  }

  Future<List<Post>> getPostsFromIds(List<String> ids) async {
    QuerySnapshot snapshots =
        await _postsRef.where(FieldPath.documentId, whereIn: ids).get();
    return snapshots.docs.map((snapshot) {
      return Post.fromSnapshot(snapshot);
    }).toList();
  }

  Future<List<Post>> getCompanionFeed(List<String> ids) async {
    try {
      QuerySnapshot snapshots =
          await _postsRef.where('authorId', whereIn: ids).get();
      return snapshots.docs.map((snapshot) {
        return Post.fromSnapshot(snapshot);
      }).toList();
    } catch (e) {
      return e.message;
    }
  }

  Future<List<Post>> getCommunityFeed(List<String> ids) async {
    try {
      QuerySnapshot snapshots =
          await _postsRef.where('communityId', whereIn: ids).get();
      return snapshots.docs.map((snapshot) {
        return Post.fromSnapshot(snapshot);
      }).toList();
    } catch (e) {
      return e.message;
    }
  }

  Future createPost(Post post) async {
    return _postsRef.add(post.toJson());
  }

  Future updatePost(
    String id, {
    String title,
    String body,
    List<String> upvotes,
    List<String> tags,
    List<String> comments,
    List<String> awards,
  }) async {
    Map<String, dynamic> data = Map();
    ({
      'title': title,
      'body': body,
      'upvotes': upvotes,
      'tags': tags,
      'comments': comments,
      'awards': awards,
    }).forEach((key, value) {
      if (value != null) data[key] = value;
    });

    return _postsRef.doc(id).update(data);
  }

  Future deletePost(String id) async {
    await _postsRef.doc(id).delete();
  }
}
