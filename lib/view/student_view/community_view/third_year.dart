// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/custome_text_field.dart';
import '../../../common_widgets/helper.dart';
import '../../../common_widgets/post_tile.dart';
import '../../../controller/store_controller.dart';
import '../../../theme.dart';
import 'comment_screen.dart';

class ThirdYear extends StatefulWidget {
  const ThirdYear({super.key});

  @override
  State<ThirdYear> createState() => _ThirdYearState();
}

class _ThirdYearState extends State<ThirdYear> {
  final controller = Get.put(StoreController());
  final postTextController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    controller.getThirdPost();
    super.initState();
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
                        hinttext: "Enter your post",
                        mycontroller: postTextController,
                        secure: false),
                  ),
                  IconButton(
                      onPressed: () {
                        controller.addPost(
                            postTextController.text, 'thirdYear');
                        postTextController.clear();
                      },
                      icon: Icon(
                        Icons.arrow_circle_up_rounded,
                        color: TColor.primary,
                        size: 40,
                      ))
                ],
              ),
            ),
       
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.thirdPost.length,
                  itemBuilder: (context, index) {
                    var post = controller.thirdPost[index];
                    return PostTile(
                        postDate: formatDate(post['timestamp']),
                        postID: post.id,
                        user: post['user'],
                        content: post['content'],
                        commentOnPressed: () {
                          Get.to(CommentScreen(
                            postId: post.id,
                          ));
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
