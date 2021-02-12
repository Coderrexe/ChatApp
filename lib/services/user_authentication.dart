import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/helper/landing.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/views/chat_rooms.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Future<int> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User firebaseUser = result.user;
      QuerySnapshot userInfoSnapshot =
          await _databaseMethods.getUserByEmail(email: firebaseUser.email);

      SharedPreferencesHelperFunctions.saveIsUserLoggedIn(isUserLoggedIn: true);
      SharedPreferencesHelperFunctions.saveUsername(
          username: userInfoSnapshot.docs[0].data()['username']);
      SharedPreferencesHelperFunctions.saveUserEmail(
          userEmail: userInfoSnapshot.docs[0].data()['email']);

      return 0;
    } catch (err) {
      print(err);
      return 1;
    }
  }

  void loginWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) {
      return;
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
  }

  Future<int> signupWithEmailAndPassword({
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
        'username': username,
        'email': firebaseUser.email,
      };

      await _databaseMethods.uploadUserInfo(
          userInfo: userInfoMap, userId: firebaseUser.uid);

      SharedPreferencesHelperFunctions.saveIsUserLoggedIn(isUserLoggedIn: true);

      SharedPreferencesHelperFunctions.saveUsername(
          username: username);

      SharedPreferencesHelperFunctions.saveUserEmail(
          userEmail: firebaseUser.email);

      return 0;
    } catch (err) {
      print(err.toString());
      return 1;
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

  Future<void> logout(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();

      SharedPreferencesHelperFunctions.saveIsUserLoggedIn(
          isUserLoggedIn: false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Landing(),
        ),
      );
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
