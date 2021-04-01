import '../../../app/locator.dart';
import '../../../app/router.dart';

import '../../../services/user/user_firestore_service.dart';
import '../../../services/navigation_service.dart';
import '../viewmodel.dart';

class SetupUserViewModel extends ViewModel {
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<String> _tags;
  List<String> get tags => _tags;

  void init() {
    _tags = [];
  }

  void addTag(String tag) {
    tag = tag[0].toUpperCase() + tag.substring(1);
    if (!_tags.contains(tag))
      _tags.add(tag);
    notifyListeners();
  }

  void deleteTag(int index) {
    _tags.removeAt(index);
    notifyListeners();
  }

  void setupUser() async {
    setBusy(true);
    await _userFirestoreService.updateUser(currentUser.id, tags: _tags);
    setBusy(false);
    skip();
  }

  void skip() {
    _navigationService.navigateReplacementTo(HomeViewRoute);
  }
}
