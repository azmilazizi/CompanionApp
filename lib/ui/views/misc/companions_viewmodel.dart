import '../../../app/locator.dart';

import '../../../services/user/user_firestore_service.dart';
import '../../../models/user.dart';
import '../viewmodel.dart';

class CompanionsViewModel extends ViewModel {
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();

  User user;

  List<User> _companions;
  List<User> get companions => _companions;

  Future initialise(User target) async {
    setBusy(true);
    user = target;
    if (user.companions.isNotEmpty)
      _companions =
          await _userFirestoreService.getUsersFromIds(user.companions);
    setBusy(false);
  }
}
