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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [TColor.primary, TColor.accent],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColor.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: TColor.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: FadeInDown(
              delay: Duration(milliseconds: 300),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: TColor.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/img/woman.png"),
                          radius: 20,
                          backgroundColor: TColor.surface,
                        ),
                      ),
                      // Online Status Indicator
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: TColor.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: TColor.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.receiverName,
                          style: TextStyle(
                            color: TColor.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Online",
                          style: TextStyle(
                            color: TColor.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColor.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.video_call_rounded,
                    color: TColor.white,
                    size: 24,
                  ),
                  onPressed: () {
                    // Video call functionality can be added here
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: TColor.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: TColor.white,
                    size: 24,
                  ),
                  onPressed: () {
                    // More options functionality can be added here
                  },
                ),
              ),
            ],
          ),
        ),
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TColor.background,
            TColor.surface,
          ],
        ),
      ),
      child: StreamBuilder(
        stream: chat.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // if has errors
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: TColor.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 60,
                      color: TColor.error,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Something went wrong",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: TColor.onSurface,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        color: TColor.onSurfaceVariant,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          //if it is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: TColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      color: TColor.primary,
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Loading messages...",
                    style: TextStyle(
                      color: TColor.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInUp(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            TColor.primary.withOpacity(0.1),
                            TColor.accent.withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 80,
                        color: TColor.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "No messages yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: TColor.onSurface,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Start the conversation by sending\nyour first message!",
                    style: TextStyle(
                      fontSize: 16,
                      color: TColor.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          //return a list of messages
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: snapshot.data!.docs
                .map((doc) => buildMessageItem(doc))
                .toList(),
          );
        },
      ),
    );
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

    return FadeInUp(
      delay: Duration(milliseconds: 100),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isCurrentUser) ...[
              CircleAvatar(
                backgroundImage: AssetImage("assets/img/woman.png"),
                radius: 16,
                backgroundColor: TColor.primary.withOpacity(0.1),
              ),
              SizedBox(width: 8),
            ],
            Flexible(
              child: EnhancedChatBubble(
                message: data["message"],
                messageTime: messageDate,
                isCurrentUser: isCurrentUser,
                messageId: doc.id,
                userId: data['senderID'],
              ),
            ),
            if (isCurrentUser) ...[
              SizedBox(width: 8),
              CircleAvatar(
                backgroundImage: AssetImage("assets/img/woman.png"),
                radius: 16,
                backgroundColor: TColor.primary.withOpacity(0.1),
              ),
            ],
          ],
        ),
      ),
    );
  }

  //========user input============
  Widget buildUserInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment Button
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {
                // Attachment functionality can be added here
              },
              icon: Icon(
                Icons.attach_file_rounded,
                color: TColor.primary,
                size: 24,
              ),
            ),
          ),
          // Text Input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: TColor.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: TColor.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: messageController,
                focusNode: myFocusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: TColor.onSurface,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(
                    color: TColor.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          // Send Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColor.primary, TColor.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: sendMessage,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.send_rounded,
                    color: TColor.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Chat Bubble Widget
class EnhancedChatBubble extends StatelessWidget {
  final String message;
  final String messageId;
  final String userId;
  final String messageTime;
  final bool isCurrentUser;

  const EnhancedChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
    required this.messageTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isCurrentUser
                ? LinearGradient(
                    colors: [TColor.primary, TColor.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isCurrentUser ? null : TColor.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft:
                  isCurrentUser ? Radius.circular(20) : Radius.circular(5),
              bottomRight:
                  isCurrentUser ? Radius.circular(5) : Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: (isCurrentUser ? TColor.primary : TColor.black)
                    .withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: isCurrentUser
                ? null
                : Border.all(
                    color: TColor.primary.withOpacity(0.2),
                    width: 1,
                  ),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isCurrentUser ? TColor.white : TColor.onSurface,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                messageTime,
                style: TextStyle(
                  fontSize: 12,
                  color: TColor.onSurfaceVariant,
                ),
              ),
              if (isCurrentUser) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.done_all_rounded,
                  size: 16,
                  color: TColor.success,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
