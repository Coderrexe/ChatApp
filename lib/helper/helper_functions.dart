import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelperFunctions {
  static String userLoggedInKey = 'IS_LOGGED_IN';
  static String usernameKey = 'USER_NAME_KEY';
  static String userEmailKey = 'USER_EMAIL_KEY';

  // Saving data to SharedPreferences.

  static Future<bool> saveIsUserLoggedIn(
      {@required bool isUserLoggedIn}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUsername({@required String username}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(usernameKey, username);
  }

  static Future<bool> saveUserEmail({@required String userEmail}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userEmailKey, userEmail);
  }

  // Getting data from SharedPreferences.

  static Future<bool> getIsUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(usernameKey);
  }

  static Future<String> getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(usernameKey);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmailKey);
  }
}
