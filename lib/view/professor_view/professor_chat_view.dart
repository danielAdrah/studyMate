// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class ProfessorChatView extends StatefulWidget {
  const ProfessorChatView({super.key});

  @override
  State<ProfessorChatView> createState() => _ProfessorChatViewState();
}

class _ProfessorChatViewState extends State<ProfessorChatView> {
  final controller = Get.put(StoreController());
  List<QueryDocumentSnapshot> students = [];
  getUsers() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where('role', isEqualTo: "Student")
        .get();

    students.addAll(data.docs);
    setState(() {});
  }

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
                  child: StreamBuilder(
                      stream: controller.getStudentsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Please Wait");
                        }
                        if (!snapshot.hasData && snapshot.data!.isEmpty) {
                          return Text(
                            "There are no profrssors yet",
                            style: TextStyle(color: Colors.black),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var student = snapshot.data![index];

                            return FadeInDown(
                              delay: Duration(milliseconds: 500),
                              child: ChatTile(
                                name: student["name"],
                                onTap: () {},
                              ),
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  ChatTile({
    super.key,
    required this.onTap,
    required this.name,
  });
  void Function()? onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                          color: TColor.primary, shape: BoxShape.circle),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/img/user.png"),
                        radius: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      name,
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
      ),
    );
  }
}
