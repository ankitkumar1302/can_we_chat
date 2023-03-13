import 'dart:developer';

import 'package:can_we_chat/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // For Auth
  static FirebaseAuth auth = FirebaseAuth.instance;

  // For accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // For storing self information
  static late ChatUser me;

  // To return current user
  static User get user => auth.currentUser!;

  // For checking if user exists or not?
  static Future<bool> userExits() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

// For getting the current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // For creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey there I am using We can Chat?",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // For getting all users form firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
}
