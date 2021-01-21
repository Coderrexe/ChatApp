import 'package:flutter/material.dart';

import 'package:chat_app/services/user_authentication.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/utils/widgets.dart';
import 'package:chat_app/views/chat_rooms.dart';

class SignupPage extends StatefulWidget {
  final Function switchToLoginPage;

  SignupPage(this.switchToLoginPage);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthMethods _authMethods = AuthMethods();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void registerAccount() async {
    if (_formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'username': _usernameController.text,
        'email': _emailController.text,
      };

      setState(() {
        _isLoading = true;
      });

      await _authMethods
          .signupWithEmailAndPassword(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) {
        _databaseMethods.uploadUserInfo(userInfo: userInfoMap);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRooms(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment(0, -0.25),
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(color: Colors.white),
                              decoration: textFieldInputDecoration('Username'),
                              validator: (value) {
                                if (value.trim().isEmpty && value.isEmpty) {
                                  return 'Please enter a username';
                                } else if (value.length < 2) {
                                  return 'This username is too short';
                                } else if (value.length > 30) {
                                  return 'This username is too long';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: textFieldInputDecoration('Email'),
                              validator: (value) {
                                if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
                                  r"@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                ).hasMatch(value)) {
                                  if (value.trim() == value) {
                                    return null;
                                  } else {
                                    return 'Email must not contain spaces';
                                  }
                                } else if (value.trim().isEmpty) {
                                  return 'Please enter an email';
                                } else {
                                  return 'This is not a valid email';
                                }
                              },
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: Colors.white),
                              decoration: textFieldInputDecoration('Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value.trim().isEmpty && value.isEmpty) {
                                  return 'Please enter a password';
                                } else if (value != value.trim()) {
                                  return 'Password must not contain spaces';
                                } else if (value.length < 6) {
                                  return 'Password must be longer than 6 '
                                      'characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      GestureDetector(
                        onTap: () {
                          registerAccount();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xff007ef4),
                                Color(0xff2a75bc),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Image.asset(
                                'assets/images/google.png',
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                            Text(
                              'Sign In with Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 22.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.switchToLoginPage();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
