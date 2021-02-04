import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  void uploadUserInfo({@required Map<String, String> userInfo}) {
    FirebaseFirestore.instance.collection('users').add(userInfo);
  }

  Future<QuerySnapshot> getUserByUsername({@required String username}) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }

  Future<QuerySnapshot> getUserByEmail({@required String email}) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  void createChatRoom({
    @required String chatRoomId,
    @required Map<String, dynamic> chatRoomMap,
  }) {
    FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .set(chatRoomMap);
  }

  Stream<QuerySnapshot> getChatRooms({@required String username}) {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('users', arrayContains: username)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatMessages({@required String chatRoomId}) {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  void sendChatMessage(
      {@required String chatRoomId,
      @required Map<String, dynamic> messageMap}) {
    FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageMap);
  }
}
