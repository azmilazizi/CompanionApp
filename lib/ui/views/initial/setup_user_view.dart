import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../shared/shared_styles.dart';
import '../widgets/partials/busy_button.dart';
import '../widgets/partials/custom_button.dart';
import 'setup_user_viewmodel.dart';

class SetupUserView extends StatefulWidget {
  @override
  _SetupUserViewState createState() => _SetupUserViewState();
}

class _SetupUserViewState extends State<SetupUserView> {
  String tag = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SetupUserViewModel>.reactive(
      viewModelBuilder: () => SetupUserViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: model.darkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          body: Container(
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Text(
                        'Welcome',
                        style: TextStyle(
                          color: model.darkMode ? Colors.white : Colors.black,
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '!',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add your interest',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Eg. Travel, Netflix, Outdoor, Photography',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(height: 40.0),
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
                            hintText: 'Add new interest',
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
                          onPressed: () => model.setupUser(),
                        ),
                        SizedBox(height: 20.0),
                        CustomButton(
                          height: 40,
                          minWidth: 200.0,
                          darkMode: model.darkMode,
                          title: 'Skip',
                          onPressed: () => model.skip(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
