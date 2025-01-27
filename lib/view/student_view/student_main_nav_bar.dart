// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme.dart';
import 'booked_courses.dart';
import 'chat_view.dart';
import 'explore_view.dart';
import 'notification_view.dart';

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
            // mainAxisAlignment: MainAxisAlignment.,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 0;
                      currentTabView = ExploreView();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/explore.svg",
                    color: selectTab == 0 ? TColor.primary : Colors.grey,
                  )
                  //  Image.asset(
                  //   "assets/img/exploreIcon.png",
                  //   color: selectTab == 0 ? TColor.primary : Colors.grey,
                  // ),
                  ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 1;
                      currentTabView = NotificationView();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/noti.svg",
                    width: 50,
                    height: 50,
                    color: selectTab == 1 ? TColor.primary : Colors.grey,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 2;
                      currentTabView = ChatView();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/chat.svg",
                    color: selectTab == 2 ? TColor.primary : Colors.grey,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 3;
                      currentTabView = BookedCourses();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/course.svg",
                    color: selectTab == 3 ? TColor.primary : Colors.grey,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
