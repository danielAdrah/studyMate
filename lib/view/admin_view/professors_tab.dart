// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custome_text_field.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'admin_appBar.dart';

class ProfessorsTab extends StatefulWidget {
  const ProfessorsTab({super.key});

  @override
  State<ProfessorsTab> createState() => _ProfessorsTabState();
}

class _ProfessorsTabState extends State<ProfessorsTab> {
  final storeController = Get.put(StoreController());
  final searchCont = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isUserSearched = false;

  updateUserActivaty(String id, active) {
    try {
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'isActive': active,
      });
      print("done active");
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteAccount(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Account deleted successfully')));
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to delete account: $e')));
                    }
                  },
                  child: Text('Delete'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                AdminAppbar(),
                SizedBox(height: 20),
                FadeInDown(
                    delay: Duration(milliseconds: 600),
                    child: SearchAndFilter(
                      searchCont: searchCont,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isUserSearched = true; // Reset search state
                          });
                        } else {
                          setState(() {
                            isUserSearched = false; // Reset search state
                          });
                        }
                      },
                    )),
                SizedBox(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 500),
                  child: Text(
                    "All Users",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .snapshots(),
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
                        if (snapshot.hasData || snapshot.data != null) {
                          List snap = snapshot.data!.docs;
                          if (isUserSearched) {
                            snap.removeWhere((e) {
                              return !e
                                  .data()["name"]
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(searchCont.text);
                            });
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                var user = snap[index];
                                if (user["email"] != auth.currentUser!.email) {
                                  return FadeInDown(
                                    delay: Duration(milliseconds: 650),
                                    child: ProfrssorTile(
                                      name: user['name'],
                                      detailOnTap: () {
                                        customDialog(context, user['name'],
                                            user['email']);
                                      },
                                      activateOnPressed: () {
                                        updateUserActivaty(user['uid'], true);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "This account has been activated")),
                                        );
                                      },
                                      deactivateOnPressed: () {
                                        updateUserActivaty(user['uid'], false);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "This account has been deActivated")),
                                        );
                                      },
                                      deleteOnPressed: () async {
                                        deleteAccount(context, user['uid']);
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                var user = snap[index];
                                if (user["email"] != auth.currentUser!.email) {
                                  return FadeInDown(
                                    delay: Duration(milliseconds: 650),
                                    child: ProfrssorTile(
                                      name: user['name'],
                                      detailOnTap: () {
                                        customDialog(context, user['name'],
                                            user['email']);
                                      },
                                      activateOnPressed: () {
                                        updateUserActivaty(user['uid'], true);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "This account has been activated")),
                                        );
                                      },
                                      deactivateOnPressed: () {
                                        updateUserActivaty(user['uid'], false);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "This account has been deactivated")),
                                        );
                                      },
                                      deleteOnPressed: () async {
                                        deleteAccount(context, user['uid']);
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          }
                        } else {
                          return Center(
                            child: Text(
                              "There are no users yet",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//===============
class ProfrssorTile extends StatelessWidget {
  const ProfrssorTile({
    super.key,
    required this.name,
    required this.detailOnTap,
    this.activateOnPressed,
    this.deactivateOnPressed,
    this.deleteOnPressed,
  });
  final String name;
  final void Function() detailOnTap;
  final void Function()? activateOnPressed;
  final void Function()? deactivateOnPressed;
  final void Function()? deleteOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(30),
        // height: height / 3,
        decoration: BoxDecoration(
          color: TColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1.5),
              blurRadius: 0.2,
              blurStyle: BlurStyle.outer,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 110,
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 15),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: detailOnTap,
              child: Text(
                "Details",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: activateOnPressed, child: Text("Activate")),
                TextButton(
                    onPressed: deactivateOnPressed, child: Text("Deactivate")),
                TextButton(onPressed: deleteOnPressed, child: Text("Delete")),
              ],
            ),
          ],
        ));
  }
}

//================
class SearchAndFilter extends StatelessWidget {
  SearchAndFilter({
    super.key,
    required this.searchCont,
    this.onChanged,
  });

  final TextEditingController searchCont;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 1.5),
                blurRadius: 0.2,
                blurStyle: BlurStyle.outer,
              )
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: CustomTextForm(
            hinttext: "Search Users",
            mycontroller: searchCont,
            secure: false,
            suffixIcon: Icons.search,
            color: TColor.primary,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

//================
Future<dynamic> customDialog(
  BuildContext context,
  String userName,
  String userMail,
) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.info_outline,
            size: 50,
            color: TColor.primary,
          ),
          backgroundColor: TColor.background,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Row(
                children: [
                  Text("Name :",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  Text(userName,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Text("Mail :",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  Text(userMail,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                ],
              ),
              SizedBox(height: 25),
            ],
          ),
        );
      });
}
