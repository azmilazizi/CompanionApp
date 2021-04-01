import 'package:flutter/foundation.dart';

import '../../../app/locator.dart';
import '../../../app/router.dart';

import '../../../services/authentication_service.dart';
import '../../../services/navigation_service.dart';
import '../../../services/dialog_service.dart';
import '../viewmodel.dart';

class RegisterViewModel extends ViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  Future register({
    @required String displayName,
    @required String username,
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.registerWithEmailAndPassword(
      displayName: displayName,
      username: username,
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateReplacementTo(SetupUserViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Registration Failure',
          description: 'General registration failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Registration Failure',
        description: result,
      );
    }
  }
}
