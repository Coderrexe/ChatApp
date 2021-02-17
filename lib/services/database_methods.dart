import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> uploadUserInfo({@required Map<String, String> userInfo}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userInfo['username'])
        .set(userInfo);
  }

  Future<QuerySnapshot> getUserByUsername({@required String username}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }

  Future<QuerySnapshot> getUserByEmail({@required String email}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> getUserBySearchQuery(
      {@required String searchQuery}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('z_searchIndices', arrayContains: searchQuery)
        .get();
  }

  Future<void> createChatRoom({
    @required String chatRoomId,
    @required Map<String, dynamic> chatRoomMap,
  }) async {
    await FirebaseFirestore.instance
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

  Future<void> sendChatMessage({
    @required String chatRoomId,
    @required Map<String, dynamic> messageMap,
  }) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageMap);
  }
}
