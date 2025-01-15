// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widgets/card_award_row.dart';
import '../common_widgets/custom_appbar.dart';
import '../common_widgets/service_Cell.dart';
import '../theme.dart';
import 'family_member_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController searchCont = TextEditingController();
  List<String> category = [
    "Family\nMembers",
    "Subscription",
    "Kids Game",
    "Orders",
    "Favorite",
    "Consulations",
    // "Settings",
    // "Payments",
  ];
  List<Color> colors = [
    Colors.cyan,
    Colors.orange,
    const Color.fromARGB(255, 211, 75, 235),
    const Color.fromARGB(255, 218, 135, 12),
    const Color.fromARGB(255, 205, 114, 221),
    Colors.lightGreen,
    // Colors.cyan,
    // Colors.lightBlue,
  ];
  List<String> images = [
    "assets/img/family.png",
    "assets/img/subscription-model.png",
    "assets/img/game.png",
    "assets/img/order.png",
    "assets/img/heart.png",
    "assets/img/talk.png",
    // "assets/img/settings.png",
    // "assets/img/payment-protection.png",
  ];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.3,
                    decoration: BoxDecoration(
                        color: TColor.primary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    right: 1,
                    child: CustomAppbar(
                      name: "Nora Ahmad",
                      tag: "@Nora",
                      icon: Icons.notifications,
                      onPressed:
                          () {}, //this will navigate to the notification view
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 35,
                    child: ZoomIn(
                      curve: Curves.decelerate,
                      delay: Duration(milliseconds: 700),
                      child: CardAwardRow(
                        award: '\$1000', //this is award money for this account
                        order:
                            "40", //this is the orders number for this account
                        onTap: () {}, //this will navigate to the cart view
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: FadeInDown(
                  delay: Duration(milliseconds: 350),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menu",
                        style: TextStyle(
                            color: TColor.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              "see more",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: TColor.black,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width / 16,
                  right: width / 16,
                  top: height / 49,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: FadeInDown(
                    delay: Duration(milliseconds: 450),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: category.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 155,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                        ),
                        itemBuilder: (context, index) {
                          return ServiceCell(
                            onTap: () {
                              // if (index == 0) {
                              //   Get.to(FamilyMemberView());
                              // }
                              switch (index) {
                                case 0:
                                  Get.to(FamilyMemberView());
                              }
                            },
                            colors: colors[index],
                            category: category[index],
                            img: images[index],
                          );
                        }),
                  ),
                ),
              ),
              FadeInDown(
                delay: Duration(milliseconds: 450),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ServiceCell(
                      onTap: () {},
                      category: "Settings",
                      colors: Colors.indigo,
                      width: 100,
                      img: "assets/img/settings.png",
                    ),
                    ServiceCell(
                      onTap: () {},
                      category: "Payments",
                      colors: Colors.cyan,
                      width: 100,
                      img: "assets/img/payment-protection.png",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
