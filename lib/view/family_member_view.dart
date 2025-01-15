// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, body_might_complete_normally_nullable, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widgets/card_award_row.dart';
import '../common_widgets/custom_appbar.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/custome_text_field.dart';
import '../common_widgets/family_member_tile.dart';
import '../controller/category_controller.dart';
import '../theme.dart';

class FamilyMemberView extends StatefulWidget {
  const FamilyMemberView({super.key});

  @override
  State<FamilyMemberView> createState() => _FamilyMemberViewState();
}

class _FamilyMemberViewState extends State<FamilyMemberView> {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController ageCont = TextEditingController();
  final TextEditingController healthCont = TextEditingController();
  final TextEditingController foodCont = TextEditingController();

  final cont = Get.put(CategoryController());
  void clearFields() {
    nameCont.clear();
    ageCont.clear();
    healthCont.clear();
    foodCont.clear();
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  List<String> gender = [
    "Male",
    "Famle",
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
              SizedBox(height: 25),
              FadeInDown(
                delay: Duration(milliseconds: 350),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // height: 100,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/img/family.png",
                          color: Colors.white,
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ),
                    // SizedBox(width: 13),
                    Text(
                      "Family Members",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                    ),
                    InkWell(
                      onTap: () {
                        //will display a dialog to enter the new member info
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                content: SizedBox(
                                  height: height / 1.14,
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: formState,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: height / 11,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 40),
                                                Text(
                                                  "Add a family member",
                                                  style: TextStyle(
                                                    color: TColor.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                IconButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      size: 30,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Center(
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: AssetImage(
                                                      "assets/img/user.png"),
                                                  // backgroundImage: controller.imagePath.value ==
                                                  //         null
                                                  //     ? AssetImage("assets/img/u1.png")
                                                  //     : FileImage(File(controller.imagePath.value!))
                                                  //         as ImageProvider<Object>?,
                                                ),
                                                Positioned(
                                                  right: 5,
                                                  bottom: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      //choose a pic
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          TColor.white,
                                                      radius: 16,
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
                                            child: Text(
                                              "Name",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomTextForm(
                                              hinttext: "Enter your name",
                                              mycontroller: nameCont,
                                              secure: false,
                                              onTap: () {},
                                              validator: (val) {
                                                if (val == "") {
                                                  return "Can't be empty";
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
                                            child: Text(
                                              "Age",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomTextForm(
                                              hinttext: "Enter your age",
                                              mycontroller: ageCont,
                                              secure: false,
                                              onTap: () {},
                                              validator: (val) {
                                                if (val == "") {
                                                  return "Can't be empty";
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
                                            child: Text(
                                              "Gender",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Obx(
                                            () => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      31, 179, 206, 231),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: DropdownButton<String>(
                                                  hint: cont
                                                          .gender.value.isEmpty
                                                      ? Text("Your gender")
                                                      : Text(cont.gender.value),
                                                  items: gender.map((e) {
                                                    return DropdownMenuItem(
                                                      value: e.toString(),
                                                      child: Text(e,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    );
                                                  }).toList(),
                                                  isExpanded: true,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  underline: Text(
                                                    "",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onChanged: (String? val) {
                                                    if (val != null) {
                                                      cont.gender.value = val;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
                                            child: Text(
                                              "Health Condition",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomTextForm(
                                              hinttext:
                                                  "Enter your Health Condition",
                                              mycontroller: healthCont,
                                              secure: false,
                                              onTap: () {},
                                              validator: (val) {
                                                if (val == "") {
                                                  return "Can't be empty";
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
                                            child: Text(
                                              "Favorite Food",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomTextForm(
                                              hinttext:
                                                  "Enter your Favorite Food",
                                              mycontroller: foodCont,
                                              secure: false,
                                              onTap: () {},
                                              validator: (val) {
                                                if (val == "") {
                                                  return "Can't be empty";
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Center(
                                            child: CustomButton(
                                                title: "Save",
                                                onTap: () {
                                                  if (formState.currentState!
                                                      .validate()) {
                                                    //here we checked if the textfields have a value
                                                    //if it does it will excute this block
                                                    //here we will add the new member

                                                    clearFields();
                                                    
                                          
                                                  } else {
                                                    //if it don't have a value it will perform this block
                                                    print("error");
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: TColor.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //this listview displays the members of each account
              Padding(
                padding: EdgeInsets.only(left: 12, top: 20, bottom: 20),
                child: ListView.builder(
                    itemCount: 5,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Divider(
                            color: const Color.fromARGB(255, 218, 214, 214),
                          ),
                          FamilyMemberTile(
                            width: width,
                            name: "The Name",
                            img: "assets/img/user.png",
                            gameOnTap: () {
                              //this will navigate to the game view
                            },
                            settingOnTap: () {
                              //this will navigate to the setting view
                            },
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
