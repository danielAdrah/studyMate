// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymate/common_widgets/custom_app_bar.dart';

import '../../common_widgets/notification_tile.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final storeController = Get.put(StoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child:
                    CustomAppBar(name: 'Ali', avatar: "assets/img/avatar.png"),
              ),
              SizedBox(height: 35),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder(
                      stream: storeController.fetchNotifications(
                          FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("no data");
                        }
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: TColor.primary));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: FadeInDown(
                                delay: Duration(milliseconds: 650),
                                child: InkWell(
                                  onTap: () {},
                                  child: NotificationTile(
                                    title: doc['title'],
                                    body: "",
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })

                  //  StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection("users")
                  //         .doc(FirebaseAuth.instance.currentUser!.uid)
                  //         .snapshots(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasError)
                  //         return Text('Error: ${snapshot.error}');
                  //       if (snapshot.connectionState == ConnectionState.waiting)
                  //         return CircularProgressIndicator();

                  //       if (snapshot.hasData || snapshot.data != null) {
                  //         List snap = snapshot.data!.docs;
                  //         return
                  //       //
                  //       }
                  //       return Text('No notifications yet!');
                  //     })
                  //
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
