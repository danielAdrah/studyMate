// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../common_widgets/service_Cell.dart';
import '../theme.dart';

class PlansView extends StatefulWidget {
  const PlansView({super.key});

  @override
  State<PlansView> createState() => _PlansViewState();
}

class _PlansViewState extends State<PlansView> {
  List<String> category = [
    "Kids\n4M - 24M",
    "Breastfeeding\n&Pregnant",
    "Kids\n3Y - 12Y",
    "Customize\nPlan",
  ];
  List<Color> colors = [
    TColor.primary,
    Colors.orange,
    const Color.fromARGB(255, 202, 104, 219),
    Colors.cyan,
  ];

  List<String> images = [
    "assets/img/smiling-baby.png",
    "assets/img/mother.png",
    "assets/img/Kids.png",
    "assets/img/plan.png",
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
              SizedBox(height: 50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: FadeInDown(
                  delay: Duration(milliseconds: 350),
                  child: Row(
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
                            "assets/img/plan.png",
                            color: Colors.white,
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                      SizedBox(width: 13),
                      Text(
                        "Plans",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 30),
                      )
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
                  height: 500,
                  child: FadeInDown(
                    delay: Duration(milliseconds: 400),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: category.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 155,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 60,
                        ),
                        itemBuilder: (context, index) {
                          return ServiceCell(
                            onTap: (){},
                            width: 130,
                            colors: colors[index],
                            category: category[index],
                            img: images[index],
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
