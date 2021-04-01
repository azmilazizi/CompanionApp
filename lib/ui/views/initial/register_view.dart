import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../shared/shared_styles.dart';
import '../widgets/partials/busy_button.dart';
import '../widgets/partials/custom_button.dart';
import './register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String displayName = '';
  String username = '';
  String email = '';
  String password = '';
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(),
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
                        'Signup',
                        style: TextStyle(
                          color: model.darkMode ? Colors.white : Colors.black,
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '.',
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: TextStyle(
                                color: model.darkMode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: mainInputDecoration.copyWith(
                                labelText: 'Display name'),
                            validator: (val) =>
                                val.isEmpty ? 'Display name is empty' : null,
                            onChanged: (val) =>
                                setState(() => displayName = val),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            style: TextStyle(
                                color: model.darkMode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: mainInputDecoration.copyWith(
                                labelText: 'Username'),
                            validator: (val) =>
                                val.isEmpty ? 'Username is empty' : null,
                            onChanged: (val) => setState(() => username = val),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            style: TextStyle(
                                color: model.darkMode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: mainInputDecoration.copyWith(
                                labelText: 'Email'),
                            validator: (val) =>
                                val.isEmpty ? 'Email is empty' : null,
                            onChanged: (val) => setState(() => email = val),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            obscureText: !visible,
                            style: TextStyle(
                                color: model.darkMode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: mainInputDecoration.copyWith(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(visible
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined),
                                onPressed: () =>
                                    setState(() => visible = !visible),
                              ),
                            ),
                            validator: (val) =>
                                val.length < 6 ? 'Password is too short' : null,
                            onChanged: (val) => setState(() => password = val),
                          ),
                          SizedBox(height: 80.0),
                          BusyButton(
                            height: 40.0,
                            minWidth: 200.0,
                            busy: model.isBusy,
                            title: 'Sign Up',
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                model.register(
                                  displayName: displayName,
                                  username: username,
                                  email: email,
                                  password: password,
                                );
                              }
                            },
                          ),
                          SizedBox(height: 20.0),
                          CustomButton(
                            height: 40,
                            minWidth: 200.0,
                            darkMode: model.darkMode,
                            title: 'Go Back',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
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
