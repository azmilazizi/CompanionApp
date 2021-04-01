import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../ui/shared/shared_styles.dart';
import '../../../ui/views/widgets/partials/busy_button.dart';
import './create_community_viewmodel.dart';

class CreateCommunityView extends StatefulWidget {
  @override
  _CreateCommunityViewState createState() => _CreateCommunityViewState();
}

class _CreateCommunityViewState extends State<CreateCommunityView> {
  final GlobalKey<FormState> _firstFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _secondFormKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String tag = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateCommunityViewModel>.reactive(
      viewModelBuilder: () => CreateCommunityViewModel(),
      builder: (context, model, child) =>
          getFormForIndex(model, model.currentIndex),
    );
  }

  Widget firstForm(CreateCommunityViewModel model) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: model.darkMode ? Colors.white : Colors.black,
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                if (_firstFormKey.currentState.validate()) model.setIndex(1);
              },
              child: Text(
                "Next",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        body: Container(
          height: double.maxFinite,
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Form(
              key: _firstFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      'Start by creating your',
                      style: TextStyle(
                        color: model.darkMode ? Colors.white : Colors.black,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      'community name',
                      style: TextStyle(
                          color: model.darkMode ? Colors.white : Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 80),
                  TextFormField(
                    initialValue: name,
                    style: TextStyle(
                        color: model.darkMode ? Colors.white : Colors.black),
                    decoration: mainInputDecoration.copyWith(
                        labelText: 'Community name'),
                    validator: (val) => val.isEmpty
                        ? 'Name cannot be empty'
                        : RegExp(r"^[a-zA-Z0-9]+$").hasMatch(val)
                            ? null
                            : 'Name cannot contain invalid character or space',
                    onChanged: (val) => setState(() => name = val),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget secondForm(CreateCommunityViewModel model) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: model.darkMode ? Colors.white : Colors.black,
            onPressed: () {
              FocusScope.of(context).unfocus();
              description = '';
              model.setIndex(0);
            },
          ),
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                if (_secondFormKey.currentState.validate()) model.setIndex(2);
              },
              child: Text(
                "Next",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        body: Container(
          height: double.maxFinite,
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Form(
              key: _secondFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      'Let people know what',
                      style: TextStyle(
                        color: model.darkMode ? Colors.white : Colors.black,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      'your community is about',
                      style: TextStyle(
                          color: model.darkMode ? Colors.white : Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 80),
                  TextFormField(
                    initialValue: description,
                    style: TextStyle(
                        color: model.darkMode ? Colors.white : Colors.black),
                    decoration:
                        mainInputDecoration.copyWith(labelText: 'Description'),
                    validator: (val) =>
                        val.isEmpty ? 'Description cannot be empty' : null,
                    onChanged: (val) => setState(() => description = val),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget thirdForm(CreateCommunityViewModel model) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: model.darkMode ? Colors.white : Colors.black,
            onPressed: () {
              FocusScope.of(context).unfocus();
              model.tags.clear();
              tag = '';
              model.setIndex(1);
            },
          ),
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
        ),
        body: Container(
          height: double.maxFinite,
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      'Now, add your',
                      style: TextStyle(
                        color: model.darkMode ? Colors.white : Colors.black,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      'community tags',
                      style: TextStyle(
                          color: model.darkMode ? Colors.white : Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 80),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 10,
                          children: [
                            for (var tag in model.tags)
                              ActionChip(
                                label: Text(tag),
                                onPressed: () =>
                                    model.deleteTag(model.tags.indexOf(tag)),
                              ),
                          ],
                        ),
                        SizedBox(height: 40.0),
                        TextField(
                          style: TextStyle(
                              color:
                                  model.darkMode ? Colors.white : Colors.black),
                          decoration: mainInputDecoration.copyWith(
                            hintText: 'Add tags',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                if (tag.isNotEmpty) model.addTag(tag);
                              },
                            ),
                          ),
                          onChanged: (val) => setState(() => tag = val),
                        ),
                        SizedBox(height: 80.0),
                        BusyButton(
                          height: 40.0,
                          minWidth: 200.0,
                          busy: model.isBusy,
                          title: 'Finish',
                          onPressed: () => model.createCommunity(
                              name: name, description: description),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget getFormForIndex(model, int index) {
    switch (index) {
      case 0:
        return firstForm(model);
        break;
      case 1:
        return secondForm(model);
        break;
      case 2:
        return thirdForm(model);
        break;
      default:
        return firstForm(model);
    }
  }
}
