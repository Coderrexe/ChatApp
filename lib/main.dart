import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/helper/landing.dart';
import 'package:chat_app/views/chat_rooms.dart';
import 'package:chat_app/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  bool _isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    await SharedPreferencesHelperFunctions.getIsUserLoggedIn()
        .then((value) async {
      if (value == null) {
        await SharedPreferencesHelperFunctions.saveIsUserLoggedIn(
            isUserLoggedIn: false);
        _isUserLoggedIn = false;
      } else {
        setState(() {
          _isUserLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Color(0xff145c9e),
        scaffoldBackgroundColor: Color(0xff1f1f1f),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
            return Text('Something went wrong!');
          } else if (snapshot.hasData) {
            return _isUserLoggedIn != null
                ? _isUserLoggedIn
                    ? ChatRooms()
                    : Landing()
                : SplashScreen();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: DisableScrollGlow(),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
