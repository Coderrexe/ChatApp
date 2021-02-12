import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database_methods.dart';
import 'package:chat_app/views/chat_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  final TextEditingController _searchController = TextEditingController();

  QuerySnapshot _searchSnapshot;

  bool _isLoading = false;
  bool _searchButtonClicked = false;

  void _initSearch() async {
    if (_searchController.text.trim().isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(milliseconds: 200));
      await _databaseMethods
          .getUserByUsername(username: _searchController.text)
          .then((snapshot) {
        setState(() {
          _searchSnapshot = snapshot;
          _isLoading = false;
        });
      });
    }
  }

  String _createChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  void _initChatRoom({@required String username}) async {
    if (Constants.currentUsername != username) {
      String chatRoomId =
          _createChatRoomId(username, Constants.currentUsername);

      List<String> users = [username, Constants.currentUsername];
      Map<String, dynamic> chatRoomMap = {
        'chatRoomId': chatRoomId,
        'users': users,
      };

      _databaseMethods.createChatRoom(
        chatRoomId: chatRoomId,
        chatRoomMap: chatRoomMap,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(chatRoomId: chatRoomId),
        ),
      );
    }
  }

  Widget _searchResultItem(
      {@required String username, @required String email}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              String chatRoomId =
                  _createChatRoomId(username, Constants.currentUsername);
              DocumentSnapshot chatRoomDocumentSnapshot =
                  await FirebaseFirestore.instance
                      .collection('chat_rooms')
                      .doc(chatRoomId)
                      .get();

              if (!chatRoomDocumentSnapshot.exists) {
                _initChatRoom(username: username);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(chatRoomId: chatRoomId),
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: Color(0xFF03806F),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchResults() {
    return _searchButtonClicked
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return _searchSnapshot.docs[index].data()['username'] !=
                      Constants.currentUsername
                  ? _searchResultItem(
                      username: _searchSnapshot.docs[index].data()['username'],
                      email: _searchSnapshot.docs[index].data()['email'],
                    )
                  : Container();
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
        elevation: 0,
      ),
      body: !_isLoading
          ? Column(
              children: <Widget>[
                Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search Username...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none,
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _searchButtonClicked = true;
                          _initSearch();
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color(0x36FFFFFF),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.search,
                            size: 21.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _searchResults(),
              ],
            )
          : Column(
              children: <Widget>[
                Container(
                  color: Color(0x54FFFFFF),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search Username...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none,
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _searchButtonClicked = true;
                          _initSearch();
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color(0x36FFFFFF),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.search,
                            size: 21.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF03806F)),
                  ),
                ),
              ],
            ),
    );
  }
}
