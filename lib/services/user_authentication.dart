import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/views/chat_rooms.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final DatabaseMethods _databaseMethods = DatabaseMethods();

  ChatAppUser _createChatAppUser({@required User user}) {
    return ChatAppUser(userId: user.uid);
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

  void loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
      await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result =
      await _firebaseAuth.signInWithCredential(credential);

      User firebaseUser = result.user;

      if (result != null) {
        await SharedPreferencesHelperFunctions.saveIsUserLoggedIn(
            isUserLoggedIn: true);
        await SharedPreferencesHelperFunctions.saveUserEmail(
            userEmail: firebaseUser.email);
        await SharedPreferencesHelperFunctions.saveUsername(
            username: firebaseUser.displayName);

        Map<String, String> userInfoMap = {
          'email': firebaseUser.email,
          'username': firebaseUser.displayName,
        };

        await _databaseMethods
            .uploadUserInfo(userInfo: userInfoMap, userId: firebaseUser.uid)
            .then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRooms(),
            ),
          );
        });
      }
    } catch (e) {
      print(e);
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
