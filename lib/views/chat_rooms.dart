import 'package:flutter/material.dart';

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/helper/landing.dart';
import 'package:chat_app/services/user_authentication.dart';
import 'package:chat_app/views/search.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }

  void getCurrentUserInfo() async {
    Constants.currentUsername =
        await SharedPreferencesHelperFunctions.getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Landing(),
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ),
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _authMethods.logout();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(),
            ),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
