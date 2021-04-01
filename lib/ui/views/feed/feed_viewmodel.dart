import '../../../app/locator.dart';

import '../../../services/user/user_firestore_service.dart';
import '../../../services/community/community_firestore_service.dart';
import '../../../services/post/post_firestore_service.dart';

import '../../../models/user.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';
import '../viewmodel.dart';

class FeedViewModel extends ViewModel {
  final PostFirestoreService _postFirestoreService =
      locator<PostFirestoreService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final CommunityFirestoreService _communityFirestoreService =
      locator<CommunityFirestoreService>();

  List<String> _ids = [];

  List<User> _authors = [];
  List<User> get authors => _authors;

  List<Community> _communities = [];
  List<Community> get communities => _communities;

  List<Post> _companionPosts = [];
  List<Post> get companionPosts => _companionPosts;

  List<Post> _communityPosts = [];
  List<Post> get communityPosts => _communityPosts;

  Future initialise() async {
    setBusy(true);
    if (currentUser != null) await getCompanionFeed();
    setBusy(false);
  }

  Future getCompanionFeed() async {
    setBusy(true);
    final companions = [...currentUser.companions];
    companions.add(currentUser.id);

    // retrieve companion feed
    _companionPosts = await _postFirestoreService.getCompanionFeed(companions);
    _companionPosts.removeWhere((post) => post.communityId.isNotEmpty);
    _companionPosts.sort((b, a) => a.createdAt.millisecondsSinceEpoch
        .compareTo(b.createdAt.millisecondsSinceEpoch));

    final users = _companionPosts.map((post) {
      if (!_ids.contains(post.authorId)) return post.authorId;
    }).toList();
    _ids.addAll(users);
    _ids.removeWhere((value) => value == null);

    _authors = await _userFirestoreService.getUsersFromIds(_ids);
    setBusy(false);
  }

  Future getCommunityFeed() async {
    setBusy(true);
    final communities = [...currentUser.communities];

    // retrieve community feed
    if (communities.isNotEmpty) {
      _communityPosts =
          await _postFirestoreService.getCommunityFeed(communities);
      _communityPosts.sort((b, a) => a.createdAt.millisecondsSinceEpoch
          .compareTo(b.createdAt.millisecondsSinceEpoch));

      final users = _communityPosts.map((post) {
        if (!_ids.contains(post.authorId)) return post.authorId;
      }).toList();
      _ids.addAll(users);
      _ids.removeWhere((value) => value == null);

      _authors = await _userFirestoreService.getUsersFromIds(_ids);
      _communities =
          await _communityFirestoreService.getCommunitiesFromIds(communities);
    }
    setBusy(false);
  }

  User getAuthor(String id) => _authors.firstWhere((author) => author.id == id);
  Community getCommunity(String id) =>
      _communities.firstWhere((community) => community.id == id);
}
