import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/comment.dart';

class CommentFirestoreService {
  final CollectionReference _commentsRef =
      FirebaseFirestore.instance.collection('comments');

  Future<Comment> getComment(String id) async {
    DocumentSnapshot snapshot = await _commentsRef.doc(id).get();
    return Comment.fromSnapshot(snapshot);
  }

  Future<List<Comment>> getComments() async {
    QuerySnapshot snapshots = await _commentsRef.get();
    return snapshots.docs
        .map((snapshot) => Comment.fromSnapshot(snapshot))
        .toList();
  }

  Future<List<Comment>> getCommentsFromIds(List<String> ids) async {
    QuerySnapshot snapshots =
        await _commentsRef.where(FieldPath.documentId, whereIn: ids).get();
    return snapshots.docs.map((snapshot) {
      return Comment.fromSnapshot(snapshot);
    }).toList();
  }

  Future createComment(Comment comment) async {
    return _commentsRef.add(comment.toJson());
  }

  Future updateComment(
    String id, {
    String title,
    String body,
    List<String> comments,
  }) async {
    Map<String, dynamic> data = Map();
    ({
      'title': title,
      'body': body,
      'comments': comments,
    }).forEach((key, value) {
      if (value != null) data[key] = value;
    });

    return _commentsRef.doc(id).update(data);
  }

  Future deleteComment(String id) async {
    await _commentsRef.doc(id).delete();
  }
}
