// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:studymate/view/student_view/profile_view.dart';
import 'package:studymate/view/student_view/study_groups_view.dart';

import '../../theme.dart';
import 'assignments_view.dart';
import 'booked_courses.dart';
import 'chat_view.dart';
import 'explore_view.dart';
import 'grades_view.dart';

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
      // backgroundColor: TColor.background,
      body: PageStorage(
        bucket: pageStorageBucket,
        child: currentTabView,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        padding: EdgeInsets.zero,
        elevation: 0.5,
        color: TColor.navBarBackground,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectTab = 0;
                    currentTabView = ExploreView();
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
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     setState(() {
              //       selectTab = 1;
              //       currentTabView = AssignmentsView();
              //     });
              //   },
              //   icon: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(
              //         Icons.assignment,
              //         color: selectTab == 1 ? TColor.primary : Colors.grey,
              //         size: 24,
              //       ),
              //       SizedBox(height: 4),
              //       Text(
              //         "Assignments",
              //         style: TextStyle(
              //           fontSize: 12,
              //           color: selectTab == 1 ? TColor.primary : Colors.grey,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

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
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectTab = 3;
                    currentTabView = StudyGroupsView();
                  });
                },
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.groups,
                      color: selectTab == 3 ? TColor.primary : Colors.grey,
                      size: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Groups",
                      style: TextStyle(
                        fontSize: 12,
                        color: selectTab == 3 ? TColor.primary : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 4;
                      currentTabView = BookedCourses();
                    });
                  },
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.book,
                        color: selectTab == 4 ? TColor.primary : Colors.grey,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Courses",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectTab == 4 ? TColor.primary : Colors.grey,
                        ),
                      ),
                    ],
                  )),
              // IconButton(
              //   onPressed: () {
              //     setState(() {
              //       selectTab = 5;
              //       currentTabView = GradesView();
              //     });
              //   },
              //   icon: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(
              //         Icons.grade,
              //         color: selectTab == 5 ? TColor.primary : Colors.grey,
              //         size: 24,
              //       ),
              //       SizedBox(height: 4),
              //       Text(
              //         "Grades",
              //         style: TextStyle(
              //           fontSize: 12,
              //           color: selectTab == 5 ? TColor.primary : Colors.grey,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              IconButton(
                onPressed: () {
                  setState(() {
                    selectTab = 6;
                    currentTabView = ProfileView();
                  });
                },
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_3_rounded,
                      color: selectTab == 6 ? TColor.primary : Colors.grey,
                      size: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 12,
                        color: selectTab == 6 ? TColor.primary : Colors.grey,
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
