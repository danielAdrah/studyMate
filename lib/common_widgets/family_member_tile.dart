// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../theme.dart';

class FamilyMemberTile extends StatelessWidget {
  const FamilyMemberTile({
    super.key,
    required this.width,
    required this.name,
    required this.img,
    required this.gameOnTap,
    required this.settingOnTap,
  });

  final double width;
  final String name;
  final String img;
  final void Function()? gameOnTap;
  final void Function()? settingOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(img),
      ),
      title: Text(
        //the name of the family member
        name,
        style: TextStyle(
          color: TColor.black,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: SizedBox(
        width: width / 4.7,
        child: Row(
          children: [
            InkWell(
              onTap: gameOnTap,
              child: CircleAvatar(
                backgroundColor: TColor.secondary,
                child: Image.asset(
                  "assets/img/game.png",
                  color: TColor.white,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            SizedBox(width: 5),
            InkWell(
              onTap: settingOnTap,
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Image.asset(
                  "assets/img/settings.png",
                  color: TColor.white,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
