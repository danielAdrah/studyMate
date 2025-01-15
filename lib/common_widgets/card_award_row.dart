// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

import '../theme.dart';

class CardAwardRow extends StatelessWidget {
  final String award;
  final String order;
  void Function()? onTap;

  CardAwardRow({
    super.key,
    required this.award,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Award",
                style: TextStyle(
                    color: TColor.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
            Text(award,
                style: TextStyle(
                    color: TColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13)),
          ],
        ),
        SizedBox(width: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Orders",
                style: TextStyle(
                    color: TColor.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
            Text(order,
                style: TextStyle(
                    color: TColor.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 13)),
          ],
        ),
        SizedBox(width: 40),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(220, 255, 153, 0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: TColor.white,
                ),
                SizedBox(width: 5),
                Text(
                  "Cart",
                  style: TextStyle(
                      color: TColor.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
