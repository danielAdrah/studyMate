// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

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

class FirstYear extends StatefulWidget {
  const FirstYear({super.key});

  @override
  State<FirstYear> createState() => _FirstYearState();
}

class _FirstYearState extends State<FirstYear> {
  final controller = Get.put(StoreController());
  final postTextController = TextEditingController();
  final commentTextController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    controller.getFirstPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
                        if (postTextController.text.isNotEmpty) {
                          controller.addPost(
                              postTextController.text, 'firstYear');
                        }

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
                  itemCount: controller.firstPost.length,
                  itemBuilder: (context, index) {
                    var post = controller.firstPost[index];
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

//===============
void showCustomSnackBar(
  BuildContext context,
  TextEditingController textController,
  double height,
) {
  var snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: TColor.white,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    duration: Duration(hours: 1),
    // padding: EdgeInsets.only(top: 10),
    content: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: CustomTextForm(
                    hinttext: "Add your comment",
                    mycontroller: textController,
                    secure: false),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_circle_up_rounded,
                    color: TColor.primary,
                    size: 40,
                  ))
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: height / 3,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage("assets/img/user.png"),
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ali ali",
                          style: TextStyle(
                              color: TColor.black, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "nice one",
                          style: TextStyle(
                              color: TColor.black, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
