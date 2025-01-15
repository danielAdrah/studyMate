// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../theme.dart';
import 'plans_view.dart';
import 'profile_view.dart.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = const ProfileView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        bucket: pageStorageBucket,
        child: currentTabView,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: BottomAppBar(
          elevation: 0.5,
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            // height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 0;
                      currentTabView = const ProfileView();
                    });
                  },
                  icon: Icon(
                    Icons.person_2_outlined,
                    size: 40,
                    color: selectTab == 0 ? TColor.primary : Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 1;
                      currentTabView = Container(color: Colors.red);
                    });
                  },
                  icon: Icon(
                    Icons.search,
                    size: 40,
                    color: selectTab == 1 ? TColor.primary : Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectTab = 2;
                      currentTabView = Container(color: Colors.blue);
                    });
                  },
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TColor.primary,
                    ),
                    child: Icon(Icons.home, size: 40, color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 3;
                      currentTabView = PlansView();
                    });
                  },
                  icon: Icon(
                    Icons.list,
                    size: 40,
                    color: selectTab == 3 ? TColor.primary : Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectTab = 4;
                      currentTabView = Container(color: Colors.blue);
                    });
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 40,
                    color: selectTab == 4 ? TColor.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
