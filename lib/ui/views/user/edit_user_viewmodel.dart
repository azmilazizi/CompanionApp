import '../../../app/locator.dart';

import '../../../services/user/user_firestore_service.dart';
import '../viewmodel.dart';

class EditUserViewModel extends ViewModel {
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();

  Future initialise() async {
    notifyListeners();
  }

  Future updateUser({
    String displayName,
    String description,
  }) async {
    setBusy(true);
    await _userFirestoreService.updateUser(
      currentUser.id,
      displayName: displayName,
      description: description,
    );
    refreshUser();
    setBusy(false);
  }
}
