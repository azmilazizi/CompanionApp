import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../ui/shared/shared_styles.dart';
import './edit_user_viewmodel.dart';

class EditUserView extends StatefulWidget {
  @override
  _EditUserViewState createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String displayName = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return ViewModelBuilder<EditUserViewModel>.reactive(
      viewModelBuilder: () => EditUserViewModel(),
      onModelReady: (model) {
        model.initialise();
        displayName = model.currentUser.displayName;
        description = model.currentUser.description;
      },
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
            'Edit Profile',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await model.updateUser(
                      displayName: displayName, description: description);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 192.0 + statusBarHeight,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Container(
                            height: 166.0,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/companion.png'),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.teal,
                            ),
                          ),
                          Container(
                            height: 166.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          Positioned(
                            top: 166.0 / 2 - 16,
                            left: MediaQuery.of(context).size.width / 2 - 16,
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 32.0,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor:
                                  model.darkMode ? Colors.black : Colors.white,
                              child: CircleAvatar(
                                radius: 38,
                                child:
                                    Image.asset('assets/icons/companion.png'),
                              ),
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.black.withOpacity(0.5),
                            ),
                            Positioned(
                              top: 22.5,
                              left: 22.5,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 32.0,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        style: TextStyle(
                            color:
                                model.darkMode ? Colors.white : Colors.black),
                        decoration:
                            mainInputDecoration.copyWith(labelText: 'Name'),
                        initialValue: model.currentUser.displayName,
                        validator: (val) =>
                            val.isEmpty ? 'Name is empty' : null,
                        onChanged: (val) => setState(() => displayName = val),
                      ),
                      SizedBox(height: 40.0),
                      TextFormField(
                        style: TextStyle(
                            color:
                                model.darkMode ? Colors.white : Colors.black),
                        decoration: mainInputDecoration.copyWith(
                            labelText: 'Description'),
                        initialValue: model.currentUser.description,
                        onChanged: (val) => setState(() => description = val),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
