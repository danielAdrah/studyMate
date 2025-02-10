// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/custome_text_field.dart';
import '../../../common_widgets/helper.dart';
import '../../../controller/store_controller.dart';
import '../../../theme.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({super.key, required this.postId});
  final String postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commentTextController = TextEditingController();

  final controller = Get.put(StoreController());
  void addComment(String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'comment': comment,
      'user': FirebaseAuth.instance.currentUser!.email,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextForm(
                          hinttext: "Enter your comment",
                          mycontroller: commentTextController,
                          secure: false),
                    ),
                    IconButton(
                        onPressed: () {
                          if (commentTextController.text.isNotEmpty) {
                            addComment(commentTextController.text);
                          }

                          commentTextController.clear();
                        },
                        icon: Icon(
                          Icons.arrow_circle_up_rounded,
                          color: TColor.primary,
                          size: 40,
                        ))
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: StreamBuilder(
                    stream: controller.fetchFirstCommentStream(widget.postId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("no data");
                      }
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: TColor.primary));
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var comment = snapshot.data![index];
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage("assets/img/pro_avatar.png"),
                              ),
                              title: Text(
                                comment['user'],
                                style: TextStyle(color: TColor.black),
                              ),
                              subtitle: Text(
                                comment['comment'],
                                style: TextStyle(color: TColor.black),
                              ),
                              trailing: Text(
                                formatDate(comment['timestamp']),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: TColor.black),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
