import 'package:flutter/material.dart';

import 'package:chat_app/services/user_authentication.dart';
import 'package:chat_app/views/chat_rooms.dart';
import 'package:chat_app/widgets.dart';

class LoginPage extends StatefulWidget {
  final Function switchToSignupPage;

  LoginPage({@required this.switchToSignupPage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthMethods _authMethods = AuthMethods();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomPadding: false,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF03806F)),
              ),
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
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: textFieldInputDecoration('Email'),
                              validator: (value) {
                                if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
                                  r"@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                ).hasMatch(value)) {
                                  return null;
                                } else if (value.trim().isEmpty) {
                                  return 'Please enter an email';
                                } else {
                                  return 'This is not a valid email';
                                }
                              },
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: Colors.white),
                              decoration: textFieldInputDecoration('Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value.contains(' ')) {
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
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            _authMethods
                                .loginWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            )
                                .then((user) {
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRooms(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF018F7C),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          _authMethods.loginWithGoogle();
                        },
                        child: Container(
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
                      ),
                      SizedBox(height: 22.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.switchToSignupPage();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                'Sign up now',
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
