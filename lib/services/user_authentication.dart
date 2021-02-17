import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/services/database_methods.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Future<User> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User firebaseUser = result.user;

      SharedPreferencesHelperFunctions.saveIsUserLoggedIn(isUserLoggedIn: true);
      SharedPreferencesHelperFunctions.saveUsername(
          username: firebaseUser.displayName);
      SharedPreferencesHelperFunctions.saveUserEmail(
          userEmail: firebaseUser.email);

      return firebaseUser;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<User> loginWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();

    if (googleSignInAccount == null) {
      return null;
    }

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
        'userID': firebaseUser.uid,
        'email': firebaseUser.email,
        'username': firebaseUser.displayName,
      };

      await _databaseMethods.uploadUserInfo(userInfo: userInfoMap);
      return firebaseUser;
    }
    return null;
  }

  Future<User> signupWithEmailAndPassword({
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
      Map<String, String> userInfoMap = {
        'userID': firebaseUser.uid,
        'username': username,
        'email': firebaseUser.email,
      };

      await _databaseMethods.uploadUserInfo(userInfo: userInfoMap);

      SharedPreferencesHelperFunctions.saveIsUserLoggedIn(isUserLoggedIn: true);
      SharedPreferencesHelperFunctions.saveUsername(username: username);
      SharedPreferencesHelperFunctions.saveUserEmail(
          userEmail: firebaseUser.email);

      return firebaseUser;
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
      await _firebaseAuth.signOut();
      SharedPreferencesHelperFunctions.saveIsUserLoggedIn(
          isUserLoggedIn: false);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
