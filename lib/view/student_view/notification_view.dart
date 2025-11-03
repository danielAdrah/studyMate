// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymate/common_widgets/custom_app_bar.dart';

import '../../common_widgets/notification_tile.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final storeController = Get.put(StoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [TColor.primary, TColor.secondary],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: TColor.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notifications",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: TColor.onSurface,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Stay updated with your courses",
                            style: TextStyle(
                              fontSize: 14,
                              color: TColor.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder(
                  stream: storeController.fetchNotifications(
                      FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    // Handle loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState();
                    }

                    // Handle error state
                    if (snapshot.hasError) {
                      return _buildErrorState(snapshot.error.toString());
                    }

                    // Handle no data/empty state
                    final notifications = snapshot.data;
                    if (notifications == null || notifications.isEmpty) {
                      return _buildEmptyState();
                    }

                    // Handle successful data loading
                    return _buildNotificationsList(notifications);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Loading State Widget
  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(TColor.primary),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Loading notifications...",
            style: TextStyle(
              color: TColor.onSurfaceVariant,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Please wait while we fetch your updates",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.onSurfaceVariant.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Error State Widget
  Widget _buildErrorState(String errorMessage) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TColor.error.withOpacity(0.1),
            ),
            child: Icon(
              Icons.error_outline,
              color: TColor.error,
              size: 40,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Connection Error",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.onSurface,
            ),
          ),
          SizedBox(height: 8),
          Text(
            errorMessage.length > 100
                ? "${errorMessage.substring(0, 100)}..."
                : errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {}); // Refresh the stream
            },
            icon: Icon(
              Icons.refresh,
              size: 18,
              color: Colors.white,
            ),
            label: Text(
              "Retry",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TColor.primary.withOpacity(0.1),
            ),
            child: Icon(
              Icons.notifications_none,
              color: TColor.primary,
              size: 40,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "No Notifications Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.onSurface,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You don't have any notifications at the moment",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Course reminders and updates will appear here",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.onSurfaceVariant.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Notifications List Widget
  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        var notification = notifications[index];
        var userId = FirebaseAuth.instance.currentUser!.uid;
        var documentId =
            notification['documentId']; // Use the document ID from Firestore

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FadeInDown(
            delay: Duration(milliseconds: 150 * index),
            child: Dismissible(
              key: Key(documentId.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: TColor.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              onDismissed: (direction) async {
                // Show loading state
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Row(
                //       children: [
                //         SizedBox(
                //           width: 20,
                //           height: 20,
                //           child: CircularProgressIndicator(
                //             strokeWidth: 2,
                //             valueColor: AlwaysStoppedAnimation(Colors.white),
                //           ),
                //         ),
                //         SizedBox(width: 12),
                //         Text('Deleting notification...'),
                //       ],
                //     ),
                //     duration: Duration(seconds: 1),
                //   ),
                // );

                try {
                  await storeController.deleteNotification(userId, documentId);

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  Get.snackbar(
                    "Done",
                    "Notification deleted successfully",
                    backgroundColor: TColor.success,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  print("Delete error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Failed to delete notification'),
                        ],
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: TColor.error,
                    ),
                  );
                  setState(() {}); // Refresh the stream
                }
              },
              child: InkWell(
                onTap: () {
                  // Mark as read when tapped
                  // This could be implemented with storeController.markNotificationAsRead()
                },
                child: NotificationTile(
                  title: notification['title'],
                  body: notification['body'] ?? '',
                  type: notification['type'],
                  professor: notification['professor'],
                  courseField: notification['courseField'],
                  scheduledDate: notification['scheduledDate'],
                  isRead: notification['isRead'] ?? false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
