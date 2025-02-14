// ignore_for_file: unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/message.dart';

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //===
  //GET ALL THE USERS
  Stream<List<Map<String, dynamic>>> getAllUserStream() {
    return firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //SEND A MESSAGE
  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = auth.currentUser!.uid;
    final String currentUserMail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //=====CREATE NEW MESSAGE
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserMail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    print("after init");

    //create chap room to store the messages
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    print("Generated chatRoomID: $chatRoomID");

    //add the new nessage to the database

    await firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

  }

  //GET THE MESSAGE
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //create a chat room for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
