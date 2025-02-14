// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/chat_bubble.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../services/chat_service.dart';
import '../../theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.receiverName, required this.receiverID});
  final String receiverName;
  final String receiverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ChatService chat = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode myFocusNode = FocusNode();

  //send a message
  void sendMessage() async {
    //make sure that there is something in the message
    if (messageController.text.isNotEmpty) {
      await chat.sendMessage(widget.receiverID, messageController.text);
    }
    messageController.clear();
    scrollDown();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          Duration(milliseconds: 300),
          () => scrollDown(),
        );
      }
    });

    //this for scrolling down the messages
    Future.delayed(
      Duration(milliseconds: 300),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    messageController.dispose();
  }

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
        ),
        iconTheme: IconThemeData(color: TColor.white),
        title: FadeInDown(
          delay: Duration(milliseconds: 300),
          child: Text(
            widget.receiverName,
            style: TextStyle(color: TColor.white),
          ),
        ),
        centerTitle: true,
        backgroundColor: TColor.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          buildUserInput(),
        ],
      ),
    );
  }

  //=========list of the messages=============
  Widget buildMessageList() {
    String senderID = auth.currentUser!.uid;
    return StreamBuilder(
        stream: chat.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // if has errors
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            );
          }

          //if it is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: TColor.primary,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No messages yet",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ));
          }

          //return a list of messages
          return ListView(
            controller: scrollController,
            children: snapshot.data!.docs
                .map((doc) => buildMessageItem(doc))
                .toList(),
          );
        });
  }

  //=====
  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == auth.currentUser!.uid;

    //timestamp for the message
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String messageDate = dateTime.toString().substring(11, 16);

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ChatBubble(
          message: data["message"],
          messageTime: messageDate,
          isCurrentUser: isCurrentUser,
          messageId: doc.id,
          userId: data['senderID'],
        ),
      ],
    );
  }

  //========user input============
  Widget buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomTextForm(
              mycontroller: messageController,
              secure: false,
              focusNode: myFocusNode,
              hinttext: "Type a message",
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: TColor.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ))))
        ],
      ),
    );
  }
}
