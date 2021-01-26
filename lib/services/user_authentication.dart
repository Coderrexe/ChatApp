import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/models/user.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ChatAppUser _createChatAppUser({@required User user}) {
    return user != null ? ChatAppUser(userId: user.uid) : null;
  }

  Future<ChatAppUser> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User firebaseUser = result.user;
      return _createChatAppUser(user: firebaseUser);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future<ChatAppUser> signupWithEmailAndPassword({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User firebaseUser = result.user;
      return _createChatAppUser(user: firebaseUser);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future<void> resetPassword({@required String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future<void> logout() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
