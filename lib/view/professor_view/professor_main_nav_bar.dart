// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme.dart';
import '../student_view/chat_view.dart';
import 'professor_course_view.dart';
import 'professor_explore.dart';
import 'professor_notification.dart';
import 'assignment_dashboard.dart';
import 'professor_profile.dart';

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
        height: 70,
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
                      currentTabView = ProfessorExplore();
                    });
                  },
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.explore,
                        color: selectTab == 0 ? TColor.primary : Colors.grey,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Explore",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectTab == 0 ? TColor.primary : Colors.grey,
                        ),
                      ),
                    ],
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 1;
                      currentTabView = AssignmentDashboard();
                    });
                  },
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.assignment,
                        color: selectTab == 1 ? TColor.primary : Colors.grey,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Assignments",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectTab == 1 ? TColor.primary : Colors.grey,
                        ),
                      ),
                    ],
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 2;
                      currentTabView = ChatView();
                    });
                  },
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat,
                        color: selectTab == 2 ? TColor.primary : Colors.grey,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Chat",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectTab == 2 ? TColor.primary : Colors.grey,
                        ),
                      ),
                    ],
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 3;
                      currentTabView = ProfessorCourseView();
                    });
                  },
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.book,
                        color: selectTab == 3 ? TColor.primary : Colors.grey,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Courses",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectTab == 3 ? TColor.primary : Colors.grey,
                        ),
                      ),
                    ],
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 4;
                      currentTabView = ProfessorProfile();
                    });
                  },
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_3,
                        color: selectTab == 4 ? TColor.primary : Colors.grey,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectTab == 4 ? TColor.primary : Colors.grey,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
