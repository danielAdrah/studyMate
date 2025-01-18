// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../theme.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.notifications,
              color: TColor.primary,
              size: 40,
            ),
            SizedBox(width: 8),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        Divider(
            color: TColor.black.withOpacity(0.2), indent: 50, endIndent: 50),
      ],
    );
  }
}
