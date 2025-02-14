import 'package:flutter/material.dart';

import '../theme.dart';

class PostTile extends StatelessWidget {
  PostTile({
    super.key,
    required this.user,
    required this.content,
    required this.commentOnPressed,
    required this.postID,
    required this.postDate,
    //  required this.time,
  });
  final String user;
  final String content;
  final String postDate;
  final String postID;

  final void Function()? commentOnPressed;
  // final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/img/woman.png"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  user,
                  style: TextStyle(
                      color: TColor.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
              Text(postDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.black, fontWeight: FontWeight.w400)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: TextStyle(color: TColor.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: commentOnPressed,
                icon: const Icon(
                  Icons.comment,
                  color: Colors.grey,
                ),
              ),

              // Text(,style: TextStyle(color:TColor.black),),
            ],
          ),
        ],
      ),
    );
  }
}
