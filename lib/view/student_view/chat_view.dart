// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../controller/store_controller.dart';
import '../../services/chat_service.dart';
import '../../theme.dart';
import 'chat_page.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final chatService = ChatService();
  final controller = Get.put(StoreController());
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
                
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: height,
                  child: StreamBuilder(
                      stream: chatService.getAllUserStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: TColor.primary));
                        }
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "There are no users yet",
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var user = snapshot.data![index];
                            //here we make sure not to display the account that opening the app now
                            if (user["email"] != auth.currentUser!.email &&
                                user['role'] != 'Admin') {
                              return FadeInDown(
                                delay: Duration(milliseconds: 500),
                                child: ChatTile(
                                  name: user["name"],
                                  onTap: () {
                                    Get.to(ChatPage(
                                      receiverName: user["name"],
                                      receiverID: user["uid"],
                                    ));
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
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
                        backgroundImage: AssetImage("assets/img/woman.png"),
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
