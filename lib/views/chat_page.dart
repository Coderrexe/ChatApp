import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database_methods.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;

  ChatPage({@required this.chatRoomId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final DatabaseMethods _databaseMethods = new DatabaseMethods();

  final TextEditingController _messageController = TextEditingController();

  Stream<QuerySnapshot> _chatMessagesStream;

  @override
  void initState() {
    super.initState();

    setState(() {
      _chatMessagesStream =
          _databaseMethods.getChatMessages(chatRoomId: widget.chatRoomId);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': _messageController.text,
        'sender': Constants.currentUsername,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      _databaseMethods.sendChatMessage(
        chatRoomId: widget.chatRoomId,
        messageMap: messageMap,
      );

      _messageController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  Widget _chatMessagesList() {
    return StreamBuilder(
      stream: _chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatMessage(
                    message: snapshot.data.docs[index].data()['message'],
                    isSentByCurrentUser:
                        snapshot.data.docs[index].data()['sender'] ==
                            Constants.currentUsername,
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
        title: Text('Chat App'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: Column(
            children: [
              Expanded(child: _chatMessagesList()),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 10.0,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Send a message...',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            _sendMessage();
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
                              Icons.send,
                              size: 21.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isSentByCurrentUser;

  ChatMessage({@required this.message, @required this.isSentByCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: isSentByCurrentUser ? 0 : 24.0,
        right: isSentByCurrentUser ? 24.0 : 0,
      ),
      alignment:
          isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(
          top: 17.0,
          bottom: 17.0,
          left: 20.0,
          right: 20.0,
        ),
        margin: isSentByCurrentUser
            ? EdgeInsets.only(left: 30.0)
            : EdgeInsets.only(right: 30.0),
        decoration: BoxDecoration(
          color: isSentByCurrentUser ? Color(0xFF03806F) : Color(0x1AFFFFFF),
          borderRadius: isSentByCurrentUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(23.0),
                  topRight: Radius.circular(23.0),
                  bottomLeft: Radius.circular(23.0),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23.0),
                  topRight: Radius.circular(23.0),
                  bottomRight: Radius.circular(23.0),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
