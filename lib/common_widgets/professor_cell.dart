// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../theme.dart';

class ProfessorCell extends StatelessWidget {
  ProfessorCell({
    super.key,
    required this.profName,
    required this.profField,
    required this.onTap,
    required this.profImg,
  });
  void Function()? onTap;
  final String profName;
  final String profField;
  final String profImg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        width: 130,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1.5),
              blurRadius: 0.2,
              blurStyle: BlurStyle.outer,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          color: TColor.white,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                child: Center(
                  child: Image.asset(profImg),
                ),
              ),
              SizedBox(height: 6),
              Text(
                profName,
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                profField,
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
