import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import './settings_viewmodel.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      disposeViewModel: true,
      createNewModelOnInsert: true,
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            'Settings',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
