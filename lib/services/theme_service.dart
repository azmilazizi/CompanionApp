import 'package:flutter/material.dart';

class ThemeService {
  bool _darkMode;
  bool get darkMode => _darkMode;
  Brightness _brightness;
  Brightness get brightness => _brightness;

  void useDarkMode(bool value) {
    _darkMode = value;
    _brightness = value ? Brightness.dark : Brightness.light;
  }
}
