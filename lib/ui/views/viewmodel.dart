import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../app/locator.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/theme_service.dart';

class ViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ThemeService _themeService = locator<ThemeService>();

  User get currentUser => _authenticationService.currentUser;
  bool get darkMode => _themeService.darkMode;
  Brightness get brightness => _themeService.brightness;

  Future refreshUser() => _authenticationService.refreshCurrentUser();
}
