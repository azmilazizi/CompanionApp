import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../widgets/companion_item.dart';
import '../../../models/user.dart';
import './companions_viewmodel.dart';

class CompanionsView extends StatelessWidget {
  final User user;

  CompanionsView({@required this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CompanionsViewModel>.reactive(
      viewModelBuilder: () => CompanionsViewModel(),
      onModelReady: (model) => model.initialise(user),
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
            'Companions',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
        ),
        body: !model.isBusy
            ? model.companions != null
                ? ListView.builder(
                    itemCount: model.companions.length,
                    itemBuilder: (context, index) {
                      final companion = model.companions[index];
                      return CompanionItem(
                        companion: companion,
                        darkMode: model.darkMode,
                      );
                    })
                : Center(
                    child: Text(
                      "No companion found ;(",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
      ),
    );
  }
}
