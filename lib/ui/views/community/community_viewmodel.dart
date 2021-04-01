import '../../../app/locator.dart';

import '../../../services/dialog_service.dart';
import '../../../services/user/user_firestore_service.dart';
import '../../../services/community/community_firestore_service.dart';
import '../../../services/post/post_rest_service.dart';

import '../../../models/community.dart';
import '../../../models/post.dart';
import '../viewmodel.dart';

class CommunityViewModel extends ViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final CommunityFirestoreService _communityFirestoreService =
      locator<CommunityFirestoreService>();
  final PostRestService _postRestService = locator<PostRestService>();

  Community _community;
  Community get community => _community;

  List<Post> _posts;
  List<Post> get posts => _posts;

  Future fetchCommunity(Community target) async {
    setBusy(true);
    _community = target;
    _community = await _communityFirestoreService.getCommunity(target.id);

    _posts = await _postRestService.getPostsForCommunity(target.id);
    _posts.sort((b, a) => a.createdAt.millisecondsSinceEpoch
        .compareTo(b.createdAt.millisecondsSinceEpoch));
    setBusy(false);
  }

  Future follow() async {
    var tempUser = currentUser;
    tempUser.communities.add(community.id);
    await _userFirestoreService.updateUser(
      tempUser.id,
      communities: tempUser.communities,
    );
    var tempCommunity = community;
    tempCommunity.companions.add(currentUser.id);
    await _communityFirestoreService.updateCommunity(
      tempCommunity.id,
      companions: tempCommunity.companions,
    );
    notifyListeners();
  }

  Future unfollow() async {
    final response = await _dialogService.showConfirmationDialog(
      title: "Leaving community",
      description: "Are you sure you want to leave ${community.name}?",
      confirmationTitle: "Yes",
      cancelTitle: "No",
    );
    if (response.confirmed) {
      var tempUser = currentUser;
      tempUser.communities.remove(community.id);
      await _userFirestoreService.updateUser(
        tempUser.id,
        communities: tempUser.communities,
      );
      var tempCommunity = community;
      tempCommunity.companions.remove(currentUser.id);
      await _communityFirestoreService.updateCommunity(
        tempCommunity.id,
        companions: tempCommunity.companions,
      );
      notifyListeners();
    }
  }
}
