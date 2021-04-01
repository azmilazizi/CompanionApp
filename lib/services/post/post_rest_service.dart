import '../../app/locator.dart';
import '../../models/post.dart';
import '../rest_service.dart';

class PostRestService {
  final RestService _rest = locator<RestService>();

  Future<Post> getPost(String id) async {
    final json = await _rest.get('post/$id');
    return Post.fromJson(json);
  }

  Future<List<Post>> getPosts() async {
    final jsonList = await _rest.get('post/all');
    if (jsonList is List)
      return jsonList.map((json) => Post.fromJson(json)).toList();
    return [];
  }

  Future<List<Post>> getPostsForUser(String id) async {
    final jsonList = await _rest.get('user/$id/posts');
    if (jsonList is List)
      return jsonList.map((json) => Post.fromJson(json)).toList();
    return [];
  }

  Future<List<Post>> getPostsForCommunity(String id) async {
    final jsonList = await _rest.get('community/$id/posts');
    if (jsonList is List)
      return jsonList.map((json) => Post.fromJson(json)).toList();
    return [];
  }

  Future<List<Post>> getCompanionFeed(String uid) async => null;

  Future<List<Post>> getCommunityFeed(String uid) async => null;

  Future createPost(Post post) async {
    final json = await _rest.post('post', data: post.toJson());
    return Post.fromJson(json);
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

    final json = await _rest.patch('post/$id', data: data);
    return Post.fromJson(json);
  }

  Future deletePost(String id) async {
    await _rest.delete('post/$id');
  }
}
