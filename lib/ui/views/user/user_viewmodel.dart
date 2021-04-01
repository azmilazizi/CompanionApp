import '../../../app/router.dart';
import '../../../app/locator.dart';

import '../../../services/navigation_service.dart';
import '../../../services/dialog_service.dart';
import '../../../services/user/user_firestore_service.dart';
import '../../../services/community/community_firestore_service.dart';
import '../../../services/post/post_rest_service.dart';

import '../../../models/user.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';
import '../viewmodel.dart';

class UserViewModel extends ViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final CommunityFirestoreService _communityFirestoreService =
      locator<CommunityFirestoreService>();
  final PostRestService _postRestService = locator<PostRestService>();
  final DialogService _dialogService = locator<DialogService>();

  User _user;
  User get user => _user;

  List<Community> _communities = [];
  List<Community> get communities => _communities;

  List<Post> _userPosts = [];
  List<Post> get userPosts => _userPosts;

  List<Post> _communityPosts = [];
  List<Post> get communityPosts => _communityPosts;

  Community getCommunity(String id) =>
      _communities.firstWhere((community) => community.id == id);

  Future fetchUser(User target) async {
    setBusy(true);
    _user = target;
    _user = await _userFirestoreService.getUser(target.id);
    await getUserPosts();
    await getCommunityPosts();
    setBusy(false);
  }

  Future getUserPosts() async {
    _userPosts = await _postRestService.getPostsForUser(_user.id);
    _userPosts.removeWhere((post) => post.communityId.isNotEmpty);
    _userPosts.sort((b, a) => a.createdAt.millisecondsSinceEpoch
        .compareTo(b.createdAt.millisecondsSinceEpoch));
  }

  Future getCommunityPosts() async {
    _communityPosts = await _postRestService.getPostsForUser(_user.id);
    _communityPosts.removeWhere((post) => post.communityId.isEmpty);
    _communityPosts.sort((b, a) => a.createdAt.millisecondsSinceEpoch
        .compareTo(b.createdAt.millisecondsSinceEpoch));

    if (_user.communities.isNotEmpty)
      _communities = await _communityFirestoreService
          .getCommunitiesFromIds(_user.communities);
  }

  Future follow() async {
    var tempUser = currentUser;
    tempUser.companions.add(user.id);
    await _userFirestoreService.updateUser(
      tempUser.id,
      companions: tempUser.companions,
    );
    tempUser = user;
    tempUser.companions.add(currentUser.id);
    await _userFirestoreService.updateUser(
      tempUser.id,
      companions: tempUser.companions,
    );
    notifyListeners();
  }

  Future unfollow() async {
    final response = await _dialogService.showConfirmationDialog(
      title: "Unfollow",
      description: "Stop following ${user.displayName}?",
      confirmationTitle: "Yes",
      cancelTitle: "No",
    );
    if (response.confirmed) {
      var tempUser = currentUser;
      tempUser.companions.remove(user.id);
      await _userFirestoreService.updateUser(
        tempUser.id,
        companions: tempUser.companions,
      );
      tempUser = user;
      tempUser.companions.remove(currentUser.id);
      await _userFirestoreService.updateUser(
        tempUser.id,
        companions: tempUser.companions,
      );
      notifyListeners();
    }
  }

  Future navigateToEditUser() async {
    await _navigationService.navigateTo(EditUserViewRoute);
    fetchUser(_user);
  }

  Future navigateToCompanions() async {
    await _navigationService
        .navigateTo(MyCompanionsViewRoute, arguments: {'user': user});
  }

  Future navigateToCommunities() async {
    await _navigationService
        .navigateTo(MyCommunitiesViewRoute, arguments: {'user': user});
  }
}
