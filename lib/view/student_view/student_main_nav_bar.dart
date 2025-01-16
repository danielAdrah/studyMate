// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../theme.dart';
import 'explore_view.dart';

class StudentMainNavBar extends StatefulWidget {
  const StudentMainNavBar({super.key});

  @override
  State<StudentMainNavBar> createState() => _StudentMainNavBarState();
}

class _StudentMainNavBarState extends State<StudentMainNavBar> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = ExploreView();
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 0;
                      currentTabView = ExploreView();
                    });
                  },
                  icon: Image.asset(
                    "assets/img/exploreIcon.png",
                    color: selectTab == 0 ? TColor.primary : Colors.grey,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 1;
                      currentTabView = Container(color: Colors.red);
                    });
                  },
                  icon: Image.asset(
                    "assets/img/notiIcon.png",
                    color: selectTab == 1 ? TColor.primary : Colors.grey,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 2;
                      currentTabView = Container();
                    });
                  },
                  icon: Image.asset(
                    "assets/img/chatIcon.png",
                    color: selectTab == 2 ? TColor.primary : Colors.grey,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 3;
                      currentTabView = Container(color: Colors.blue);
                    });
                  },
                  icon: Image.asset(
                    "assets/img/courseIcon.png",
                    color: selectTab == 3 ? TColor.primary : Colors.grey,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
