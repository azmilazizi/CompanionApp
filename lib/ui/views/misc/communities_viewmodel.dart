import '../../../app/locator.dart';

import '../../../services/community/community_firestore_service.dart';
import '../../../models/user.dart';
import '../../../models/community.dart';
import '../viewmodel.dart';

class CommunitiesViewModel extends ViewModel {
  final CommunityFirestoreService _communityFirestoreService =
      locator<CommunityFirestoreService>();

  User user;

  List<Community> _communities;
  List<Community> get communities => _communities;

  Future initialise(User target) async {
    setBusy(true);
    user = target;
    if (user.communities.isNotEmpty)
      _communities = await _communityFirestoreService
          .getCommunitiesFromIds(user.communities);
    setBusy(false);
  }
}
