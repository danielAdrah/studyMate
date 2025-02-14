// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme.dart';
import '../student_view/chat_view.dart';
import 'professor_course_view.dart';
import 'professor_explore.dart';
import 'professor_notification.dart';

class ProfessorMainNavBar extends StatefulWidget {
  const ProfessorMainNavBar({super.key});

  @override
  State<ProfessorMainNavBar> createState() => _ProfessorMainNavBarState();
}

class _ProfessorMainNavBarState extends State<ProfessorMainNavBar> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = ProfessorExplore();
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 0;
                      currentTabView = ProfessorExplore();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/explore.svg",
                    color: selectTab == 0 ? TColor.primary : Colors.grey,
                    height: 50,
                    width: 50,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 1;
                      currentTabView = ProfessorNotification();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/noti.svg",
                    color: selectTab == 1 ? TColor.primary : Colors.grey,
                    height: 50,
                    width: 50,
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
                    height: 50,
                    width: 50,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 3;
                      currentTabView = ProfessorCourseView();
                    });
                  },
                  icon: SvgPicture.asset(
                    "assets/img/course.svg",
                    color: selectTab == 3 ? TColor.primary : Colors.grey,
                    height: 50,
                    width: 50,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
