// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme.dart';
import 'courses_tab.dart';
import 'professors_tab.dart';
import 'reports_tab.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = ProfessorsTab();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: PageStorage(
        bucket: pageStorageBucket,
        child: currentTabView,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        padding: EdgeInsets.zero,
        elevation: 0.5,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectTab = 0;
                    currentTabView = ProfessorsTab();
                  });
                },
                icon: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: selectTab == 0 ? TColor.primary : Colors.grey,
                      size: 40,
                    ),
                    Text(
                      "Users",
                      style: TextStyle(
                        color: selectTab == 0 ? TColor.primary : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 1;
                      currentTabView = CoursesTab();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/course.svg",
                    width: 50,
                    height: 50,
                    color: selectTab == 1 ? TColor.primary : Colors.grey,
                  )),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectTab = 2;
                    currentTabView = ReportsTab();
                  });
                },
                icon: Column(
                  children: [
                    Icon(
                      CupertinoIcons.doc_chart,
                      color: selectTab == 2 ? TColor.primary : Colors.grey,
                      size: 37,
                    ),
                    Text(
                      "Reports",
                      style: TextStyle(
                        color: selectTab == 2 ? TColor.primary : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
