// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../controller/store_controller.dart';
import '../../services/chat_service.dart';
import '../../theme.dart';
import 'chat_page.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final chatService = ChatService();
  final controller = Get.put(StoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header Section
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [TColor.primary, TColor.accent],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: TColor.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomAppBar(),
                  SizedBox(height: 15),
                  FadeInDown(
                    delay: Duration(milliseconds: 200),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: TColor.white,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Messages",
                          style: TextStyle(
                            color: TColor.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Enhanced Chat List
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder(
                  stream: chatService.getAllUserStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: TColor.error,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Something went wrong",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: TColor.onSurface,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: TColor.primary,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Loading conversations...",
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInUp(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  size: 60,
                                  color: TColor.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "No conversations yet",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: TColor.onSurface,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Start chatting with professors and students",
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var user = snapshot.data![index];
                        //here we make sure not to display the account that opening the app now
                        if (user["email"] != auth.currentUser!.email &&
                            user['role'] != 'Admin') {
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: ChatTile(
                              name: user["name"],
                              role: user["role"] ?? "Student",
                              onTap: () {
                                Get.to(
                                  () => ChatPage(
                                    receiverName: user["name"],
                                    receiverID: user["uid"],
                                  ),
                                  transition: Transition.rightToLeft,
                                  duration: Duration(milliseconds: 300),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatefulWidget {
  ChatTile({
    super.key,
    required this.onTap,
    required this.name,
    required this.role,
  });
  void Function()? onTap;
  final String name;
  final String role;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) {
              _animationController.reverse();
              widget.onTap?.call();
            },
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TColor.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: TColor.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: TColor.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Enhanced Avatar with Status Indicator
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [TColor.primary, TColor.accent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/img/woman.png"),
                          radius: 28,
                          backgroundColor: TColor.surface,
                        ),
                      ),
                      // Online Status Indicator
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: TColor.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: TColor.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            color: TColor.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: widget.role == "Professor"
                                    ? TColor.secondary.withOpacity(0.2)
                                    : TColor.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.role,
                                style: TextStyle(
                                  color: widget.role == "Professor"
                                      ? TColor.secondary
                                      : TColor.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: TColor.success,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Online",
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow Icon with Animation
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: TColor.primary,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
