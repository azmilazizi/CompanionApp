import '../../../app/locator.dart';
import '../../../app/router.dart';

import '../../../services/authentication_service.dart';
import '../../../services/navigation_service.dart';
import '../../../services/push_notification_service.dart';

import '../viewmodel.dart';

class SplashViewModel extends ViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  Future handleStartUpLogic() async {
    // Register for push notifications
    await _pushNotificationService.initialise();

    var hasSignedInUser = await _authenticationService.isUserSignedIn();

    if (currentUser != null) {
      print(currentUser.id);
      print(currentUser.toJson());
    }
    if (hasSignedInUser) {
      _navigationService.navigateReplacementTo(HomeViewRoute);
    } else {
      _navigationService.navigateReplacementTo(LoginViewRoute);
    }
  }
}
