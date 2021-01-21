import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/services/database_methods.dart';

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

  void initSearch() async {
    await _databaseMethods
        .getUserByUsername(username: _searchController.text)
        .then((snapshot) {
      setState(() {
        _searchSnapshot = snapshot;
      });
    });
  }

  void initChatroom(String username) {
    _databaseMethods.createChatRoom(chatRoomId: null, chatRoomMap: null);
  }

  Widget searchResults() {
    return _searchButtonClicked
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchResultItem(
                username: _searchSnapshot.docs[index].data()['username'],
                email: _searchSnapshot.docs[index].data()['email'],
              );
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
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _searchButtonClicked = true;
                      initSearch();
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color(0x36ffffff),
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
            searchResults(),
          ],
        ),
      ),
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final String username;
  final String email;

  SearchResultItem({this.username, this.email});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              // initChatroom();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: Colors.blue,
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
}
