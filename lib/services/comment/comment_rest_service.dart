import '../../app/locator.dart';
import '../../models/comment.dart';
import '../rest_service.dart';

class CommentRestService {
  final RestService _rest = locator<RestService>();

  Future<Comment> getComment(String id) async {
    final json = await _rest.get('comment/$id');
    return Comment.fromJson(json);
  }

  Future<List<Comment>> getComments() async {
    final jsonList = await _rest.get('comment/all');
    if (jsonList is List)
      return jsonList.map((json) => Comment.fromJson(json)).toList();
    return [];
  }

  Future<List<Comment>> getCommentsForPost(String id) async {
    final jsonList = await _rest.get('post/$id/comments');
    if (jsonList is List)
      return jsonList.map((json) => Comment.fromJson(json)).toList();
    return [];
  }

  Future createComment(Comment comment) async {
    final json = await _rest.post('comment', data: comment.toJson());
    return Comment.fromJson(json);
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

    final json = await _rest.patch('comment/$id', data: data);
    return Comment.fromJson(json);
  }

  Future deleteComment(String id) async {
    await _rest.delete('comment/$id');
  }
}
