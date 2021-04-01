import 'package:flutter/foundation.dart';

import '../../../app/locator.dart';
import '../../../app/router.dart';

import '../../../services/authentication_service.dart';
import '../../../services/navigation_service.dart';
import '../../../services/dialog_service.dart';
import '../viewmodel.dart';

class LoginViewModel extends ViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signIn({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateReplacementTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  void navigateToRegistration() {
    _navigationService.navigateTo(RegisterViewRoute);
  }
}
