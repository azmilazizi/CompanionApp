import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../app/router.dart';
import '../../../app/locator.dart';

import '../../../services/navigation_service.dart';
import '../../../services/user/user_firestore_service.dart';
import '../../../services/post/post_firestore_service.dart';
import '../../../services/community/community_firestore_service.dart';

import '../../../models/post.dart';
import '../../../models/community.dart';
import '../viewmodel.dart';

class CreatePostViewModel extends ViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final PostFirestoreService _postFirestoreService =
      locator<PostFirestoreService>();
  final CommunityFirestoreService _communityFirestoreService =
      locator<CommunityFirestoreService>();

  dynamic _target;
  dynamic get target => _target;

  List<Community> _communities = [];
  List<Community> get communities => _communities;

  List<String> _tags = [];
  List<String> get tags => _tags;

  void addTag(String tag) {
    tag = tag[0].toUpperCase() + tag.substring(1);
    if (!_tags.contains(tag)) _tags.add(tag);
    notifyListeners();
  }

  void deleteTag(int index) {
    _tags.removeAt(index);
    notifyListeners();
  }

  Future selectWhereToPost() async {
    _target = await _navigationService.navigateTo(SelectWhereToPostViewRoute);
    notifyListeners();
  }

  Future initWhereToPost() async {
    setBusy(true);
    if (currentUser.communities.isNotEmpty) {
      _communities = await _communityFirestoreService
          .getCommunitiesFromIds(currentUser.communities);
    }
    setBusy(false);
  }

  Future createPost({@required String title, String body}) async {
    setBusy(true);
    final tempUser = currentUser;
    final post = Post.createNew(
      authorId: currentUser.id,
      communityId: _target is Community ? _target.id : '',
      title: title,
      body: body,
      mediaType: 'text',
    );
    post.tags = _tags;
    final result = await _postFirestoreService.createPost(post);

    if (result is DocumentReference)
      tempUser.posts.add(result.id);
    else if (result is Map) tempUser.posts.add(result['id']);

    await _userFirestoreService.updateUser(
      currentUser.id,
      posts: tempUser.posts,
    );

    if (_target is Community) {
      final community = _target as Community;
      if (result is DocumentReference)
        community.posts.add(result.id);
      else if (result is Map) community.posts.add(result['id']);

      await _communityFirestoreService.updateCommunity(
        community.id,
        posts: community.posts,
      );
    }
    setBusy(false);
  }
}
