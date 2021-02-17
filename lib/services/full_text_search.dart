import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullTextSearch {
  void uploadUsersSearchIndices({@required String username}) async {
    List<String> splitList = username.split(' ');
    print(splitList);
    List<String> indexList = [];

    // An algorithm that takes increasingly-lengthened substrings from a certain
    // string (i.e. string -> s, st, str, stri, strin, string). If the string
    // contains spaces, the words inside the string will be split, and treated
    // separately.
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 1; j <= splitList[i].length; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }

    FirebaseFirestore.instance.collection('users').doc(username).update({
      'z_searchIndices': indexList,
    });
  }
}
