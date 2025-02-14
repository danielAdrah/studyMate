// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../theme.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String messageId;
  final String userId;
  final String messageTime;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
    required this.messageTime,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            decoration: BoxDecoration(
              color: isCurrentUser ? TColor.primary : TColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style:
                  TextStyle(color: isCurrentUser ? Colors.white : Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
              messageTime,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
