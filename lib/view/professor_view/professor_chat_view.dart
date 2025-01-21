// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../theme.dart';

class ProfessorChatView extends StatefulWidget {
  const ProfessorChatView({super.key});

  @override
  State<ProfessorChatView> createState() => _ProfessorChatViewState();
}

class _ProfessorChatViewState extends State<ProfessorChatView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomAppBar(
                  name: "Ali",
                  avatar: "assets/img/avatar.png",
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: TColor.primary,
                                          shape: BoxShape.circle),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            AssetImage("assets/img/user.png"),
                                        radius: 30,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Ahmad Hasan",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                            Divider(
                                color: TColor.black.withOpacity(0.2),
                                indent: 50,
                                endIndent: 50),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
