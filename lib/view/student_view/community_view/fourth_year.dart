// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/custome_text_field.dart';
import '../../../common_widgets/helper.dart';
import '../../../controller/store_controller.dart';
import '../../../theme.dart';
import 'comment_screen.dart';

class FourthYear extends StatefulWidget {
  const FourthYear({super.key});

  @override
  State<FourthYear> createState() => _FourthYearState();
}

class _FourthYearState extends State<FourthYear> {
  final controller = Get.put(StoreController());
  final postTextController = TextEditingController();
  final commentTextController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    controller.getFourthPost();
    controller.getCurrentUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [TColor.primary, TColor.accent],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: TColor.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TColor.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            color: TColor.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fourth Year Community",
                                style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Share your thoughts with classmates",
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced Posts List (Now takes most of the space)
            Expanded(
              child: Obx(
                () => controller.fourthPost.isEmpty
                    ? Center(
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      TColor.primary.withOpacity(0.1),
                                      TColor.accent.withOpacity(0.1),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.forum_outlined,
                                  size: 80,
                                  color: TColor.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "No posts yet!",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: TColor.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Be the first to share something\nwith your classmates!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: TColor.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: controller.fourthPost.length,
                        itemBuilder: (context, index) {
                          var post = controller.fourthPost[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: EnhancedPostTile(
                              postDate: formatDate(post['timestamp']),
                              postID: post.id,
                              user: post['user'],
                              content: post['content'],
                              yearLabel: "Fourth Year",
                              commentOnPressed: () {
                                Get.to(
                                  () => CommentScreen(
                                    postId: post.id,
                                  ),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Enhanced Post Input Section (Moved to bottom)
            Container(
              decoration: BoxDecoration(
                color: TColor.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: TColor.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: TColor.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                const AssetImage("assets/img/woman.png"),
                            backgroundColor: TColor.primary.withOpacity(0.1),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "What's on your mind?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: TColor.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          // Attachment Button
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Attachment functionality can be added here
                              },
                              icon: Icon(
                                Icons.attach_file_rounded,
                                color: TColor.primary,
                                size: 24,
                              ),
                            ),
                          ),
                          // Text Input
                          Expanded(
                            child: Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: TColor.background,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: TColor.primary.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: postTextController,
                                  maxLines: null,
                                  enabled: !controller.addPostLoading.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: controller.addPostLoading.value
                                        ? "Sharing your post..."
                                        : "Share your thoughts with classmates...",
                                    hintStyle: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    suffixIcon: controller.addPostLoading.value
                                        ? Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  TColor.primary,
                                                ),
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Send Button
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [TColor.primary, TColor.accent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () async {
                                  if (postTextController.text.isNotEmpty) {
                                    try {
                                      await controller.addPost(
                                        postTextController.text,
                                        'fourthYear',
                                        controller.userName.value,
                                      );
                                      postTextController.clear();
                                      // Show success feedback
                                      Get.snackbar(
                                        "Success",
                                        "Your post has been shared!",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            TColor.primary.withOpacity(0.8),
                                        colorText: TColor.white,
                                        duration: const Duration(seconds: 2),
                                        margin: const EdgeInsets.all(16),
                                        borderRadius: 12,
                                        icon: Icon(
                                          Icons.check_circle,
                                          color: TColor.white,
                                        ),
                                      );
                                    } catch (e) {
                                      // Show error feedback
                                      Get.snackbar(
                                        "Error",
                                        "Failed to share post. Please try again.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            TColor.error.withOpacity(0.8),
                                        colorText: TColor.white,
                                        duration: const Duration(seconds: 3),
                                        margin: const EdgeInsets.all(16),
                                        borderRadius: 12,
                                        icon: Icon(
                                          Icons.error,
                                          color: TColor.white,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Obx(
                                    () => controller.addPostLoading.value
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                TColor.white,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.send_rounded,
                                            color: TColor.white,
                                            size: 24,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced Post Tile Widget
class EnhancedPostTile extends StatefulWidget {
  const EnhancedPostTile({
    super.key,
    required this.user,
    required this.content,
    required this.commentOnPressed,
    required this.postID,
    required this.postDate,
    required this.yearLabel,
  });

  final String user;
  final String content;
  final String postDate;
  final String postID;
  final String yearLabel;
  final void Function()? commentOnPressed;

  @override
  State<EnhancedPostTile> createState() => _EnhancedPostTileState();
}

class _EnhancedPostTileState extends State<EnhancedPostTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Generate random like count for demo
    likeCount = (5 + (widget.postID.hashCode % 20)).abs();
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
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TColor.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: TColor.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Header
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [TColor.primary, TColor.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                const AssetImage("assets/img/woman.png"),
                            backgroundColor: TColor.surface,
                          ),
                        ),
                        // Online Status Indicator
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user,
                            style: TextStyle(
                              color: TColor.onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.yearLabel,
                                  style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.postDate,
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
                    // More Options
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: TColor.primary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Post Content
                Text(
                  widget.content,
                  style: TextStyle(
                    color: TColor.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Engagement Stats
                Row(
                  children: [
                    Text(
                      "$likeCount likes",
                      style: TextStyle(
                        color: TColor.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "View comments",
                      style: TextStyle(
                        color: TColor.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Buttons
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: TColor.primary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Like Button
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                                likeCount += isLiked ? 1 : -1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isLiked
                                        ? TColor.error
                                        : TColor.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Like",
                                    style: TextStyle(
                                      color: isLiked
                                          ? TColor.error
                                          : TColor.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Comment Button
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              _animationController.forward().then((_) {
                                _animationController.reverse();
                                widget.commentOnPressed?.call();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: TColor.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Comment",
                                    style: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Share Button
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Share functionality can be added here
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    color: TColor.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Share",
                                    style: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
