import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

import '../app/locator.dart';
import '../models/user.dart';
import './user/user_firestore_service.dart';

class AuthenticationService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();

  User _currentUser;
  User get currentUser => _currentUser;

  Future signInAnonymously() async {
    try {
      auth.UserCredential userCredential =
          await _firebaseAuth.signInAnonymously();
      auth.User user = userCredential.user;
      return user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signInWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      auth.User user = userCredential.user;
      await _populateCurrentUser(user);
      return user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future registerWithEmailAndPassword({
    @required String displayName,
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      auth.User user = userCredential.user;

      // create a new document for the user with the uid
      _currentUser = User.createNew(
        id: user.uid,
        email: email,
        username: username,
        displayName: displayName,
      );
      await _userFirestoreService.createUser(_currentUser);
      return user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
      return _populateCurrentUser(null);
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserSignedIn() async {
    auth.User user = _firebaseAuth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future<void> _populateCurrentUser(auth.User user) async {
    if (user != null) {
      _currentUser = await _userFirestoreService.getUser(user.uid);
    } else
      _currentUser = null;
  }

  Future<void> refreshCurrentUser() async {
    _currentUser = await _userFirestoreService.getUser(currentUser.id);
  }
}
