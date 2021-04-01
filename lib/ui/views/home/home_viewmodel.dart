import '../../../app/locator.dart';
import '../../../app/router.dart';

import '../../../services/authentication_service.dart';
import '../../../services/navigation_service.dart';
import '../viewmodel.dart';

class HomeViewModel extends ViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _reverse = false;
  bool get reverse => _reverse;

  void setIndex(int value) async {
    if (value < _currentIndex) {
      _reverse = true;
    } else {
      _reverse = false;
    }
    int prevIndex = currentIndex;
    _currentIndex = value;
    if (_currentIndex == 2) {
      await _navigationService.navigateTo(CreatePostViewRoute);
      _currentIndex = prevIndex;
    }
    notifyListeners();
  }

  bool isIndexSelected(int index) => _currentIndex == index;

  bool _isSearch = false;
  bool get isSearch => _isSearch;

  void useSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  Future navigateToProfile() async {
    await _navigationService
        .navigateTo(UserViewRoute, arguments: {'user': currentUser});
  }

  Future navigateToMyCompanions() async {
    await _navigationService
        .navigateTo(MyCompanionsViewRoute, arguments: {'user': currentUser});
  }

  Future navigateToMyCommunities() async {
    await _navigationService
        .navigateTo(MyCommunitiesViewRoute, arguments: {'user': currentUser});
  }

  Future navigateToSettings() async {
    await _navigationService.navigateTo(SettingsViewRoute);
  }

  Future signOut() async {
    await _authenticationService.signOut();
    await _navigationService.navigateReplacementTo(LoginViewRoute);
    setBusy(false);
  }
}
