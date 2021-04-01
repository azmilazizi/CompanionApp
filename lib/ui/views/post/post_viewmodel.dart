import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../app/locator.dart';
import '../../../app/router.dart';

import '../../../services/navigation_service.dart';
import '../../../services/user/user_firestore_service.dart';
import '../../../services/post/post_firestore_service.dart';
import '../../../services/comment/comment_firestore_service.dart';
import '../../../models/user.dart';
import '../../../models/post.dart';
import '../../../models/comment.dart';
import '../viewmodel.dart';

class PostViewModel extends ViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final PostFirestoreService _postFirestoreService =
      locator<PostFirestoreService>();
  final CommentFirestoreService _commentFirestoreService =
      locator<CommentFirestoreService>();

  bool _upvote = false;
  bool get upvote => _upvote;

  Post _post;
  Post get post => _post;

  List<User> _authors;
  List<User> get authors => _authors;

  List<Comment> _comments;
  List<Comment> get comments => _comments;

  Future fetchPost(Post target) async {
    setBusy(true);
    List<String> users = [];
    _post = target;
    _post = await _postFirestoreService.getPost(target.id);

    if (post.upvotes.contains(currentUser.id))
      _upvote = true;
    else
      _upvote = false;

    if (post.comments.isNotEmpty) {
      _comments =
          await _commentFirestoreService.getCommentsFromIds(_post.comments);
      _comments.sort((b, a) => a.createdAt.millisecondsSinceEpoch
          .compareTo(b.createdAt.millisecondsSinceEpoch));
      final temp = _comments.map((comment) {
        if (!users.contains(comment.authorId)) return comment.authorId;
      }).toList();
      users.addAll(temp);

      if (users.isNotEmpty)
        _authors = await _userFirestoreService.getUsersFromIds(users);
    }
    setBusy(false);
  }

  Future navigateToCreateComment() async {
    await _navigationService
        .navigateTo(CreateCommentViewRoute, arguments: {'post': post});
    fetchPost(_post);
  }

  void createComment({String body}) async {
    setBusy(true);
    final comment = Comment.createNew(
      authorId: currentUser.id,
      postId: post.id,
      body: body,
    );
    final result = await _commentFirestoreService.createComment(comment);

    if (result is DocumentReference)
      post.comments.add(result.id);
    else if (result is Map) post.comments.add(result['id']);

    await _postFirestoreService.updatePost(post.id, comments: post.comments);
    setBusy(false);
  }

  void toggleUpvote() async {
    setBusy(true);
    if (upvote) {
      _upvote = false;
      post.upvotes.remove(currentUser.id);
      await _postFirestoreService.updatePost(
        post.id,
        upvotes: post.upvotes,
      );
    } else {
      _upvote = true;
      post.upvotes.add(currentUser.id);
      await _postFirestoreService.updatePost(
        post.id,
        upvotes: post.upvotes,
      );
    }
    setBusy(false);
  }

  User getAuthor(String id) => _authors.firstWhere((author) => author.id == id);
}
