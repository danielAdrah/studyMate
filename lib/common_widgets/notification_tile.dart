// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../theme.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
    this.type,
    this.professor,
    this.courseField,
    this.scheduledDate,
    this.isRead = false,
  });
  final String title;
  final String body;
  final String? type;
  final String? professor;
  final String? courseField;
  final Timestamp? scheduledDate;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    IconData notificationIcon = Icons.notifications;
    Color iconColor = TColor.primary;

    // Set icon based on notification type
    if (type == 'course_reminder') {
      notificationIcon = Icons.schedule;
      iconColor = TColor.accent;
    } else if (type == 'course_booking') {
      notificationIcon = Icons.book_online;
      iconColor = TColor.secondary;
    }

    return Container(
      decoration: BoxDecoration(
        color: isRead ? TColor.background : TColor.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? Colors.transparent : TColor.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  notificationIcon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: TColor.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColor.onSurfaceVariant,
                      ),
                    ),
                    if (professor != null) ...[
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: TColor.onSurfaceVariant,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Professor: $professor",
                            style: TextStyle(
                              fontSize: 12,
                              color: TColor.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (courseField != null) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 16,
                            color: TColor.onSurfaceVariant,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Field: $courseField",
                            style: TextStyle(
                              fontSize: 12,
                              color: TColor.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (scheduledDate != null) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: TColor.onSurfaceVariant,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Scheduled: ${DateFormat('MMM dd, yyyy - h:mm a').format(scheduledDate!.toDate())}",
                            style: TextStyle(
                              fontSize: 12,
                              color: TColor.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
