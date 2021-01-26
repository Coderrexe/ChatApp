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

  void createChatRoom(
      {@required String chatRoomId, @required Map chatRoomMap}) {
    FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .set(chatRoomMap);
  }
}
