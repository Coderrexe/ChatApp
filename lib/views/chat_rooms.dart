import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/helper/landing.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/services/user_authentication.dart';
import 'package:chat_app/views/chat_page.dart';
import 'package:chat_app/views/search.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  final AuthMethods _authMethods = AuthMethods();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Stream<QuerySnapshot> _chatRoomsStream;

  @override
  void initState() {
    super.initState();
    _getCurrentUserInfo();
  }

  void _getCurrentUserInfo() async {
    Constants.currentUsername =
        await SharedPreferencesHelperFunctions.getUsername();

    setState(() {
      _chatRoomsStream =
          _databaseMethods.getChatRooms(username: Constants.currentUsername);
    });
  }

  Widget _chatRoomsList() {
    return StreamBuilder(
      stream: _chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    username: snapshot.data.docs[index]
                        .data()['chatRoomId']
                        .toString()
                        .replaceAll('_', '')
                        .replaceAll(Constants.currentUsername, ''),
                    chatRoomId: snapshot.data.docs[index].data()['chatRoomId'],
                  );
                },
              )
            : Container();
      },
    );
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
        elevation: 0,
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
        backgroundColor: Color(0xFF018F7C),
        child: Icon(Icons.search),
      ),
      body: _chatRoomsList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  ChatRoomTile({@required this.username, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(chatRoomId: chatRoomId),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF03806F),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                '${username.substring(0, 1)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
