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

class CommentScreen extends StatefulWidget {
  CommentScreen({super.key, required this.postId});
  final String postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commentTextController = TextEditingController();
  final controller = Get.put(StoreController());

  @override
  void initState() {
    controller.getCurrentUserName();
    super.initState();
  }

  void addComment(String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'comment': comment,
      'user': controller.userName.value,
      'timestamp': Timestamp.now(),
    });
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
                          decoration: BoxDecoration(
                            color: TColor.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: TColor.white,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Comments",
                                style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Join the conversation",
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: TColor.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: TColor.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced Comments List (Now takes most of the space)
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: StreamBuilder(
                  stream: controller.fetchFirstCommentStream(widget.postId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: FadeInUp(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: TColor.error.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  size: 60,
                                  color: TColor.error,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Something went wrong",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: TColor.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
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
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: TColor.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: CircularProgressIndicator(
                                color: TColor.primary,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading comments...",
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: SingleChildScrollView(
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
                                    Icons.chat_bubble_outline_rounded,
                                    size: 80,
                                    color: TColor.primary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "No comments yet",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: TColor.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Be the first to share your thoughts\nabout this post!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: TColor.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var comment = snapshot.data![index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 100 * index),
                          child: EnhancedCommentTile(
                            user: comment['user'],
                            comment: comment['comment'],
                            timestamp: formatDate(comment['timestamp']),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Enhanced Comment Input Section (Moved to bottom)
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
                            "Add a comment",
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
                                  controller: commentTextController,
                                  maxLines: null,
                                  enabled: !controller.addPostLoading.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: controller.addPostLoading.value
                                        ? "Sharing your comment..."
                                        : "Share your thoughts about this post...",
                                    hintStyle: TextStyle(
                                      color: TColor.onSurfaceVariant,
                                      fontSize: 15,
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
                                  if (commentTextController.text.isNotEmpty) {
                                    try {
                                      await controller.addComment(
                                        commentTextController.text,
                                        widget.postId,
                                      );
                                      commentTextController.clear();
                                      // Show success feedback
                                      Get.snackbar(
                                        "Success",
                                        "Your comment has been shared!",
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
                                        "Failed to share comment. Please try again.",
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
                                            width: 22,
                                            height: 22,
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
                                            size: 22,
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

// Enhanced Comment Tile Widget
class EnhancedCommentTile extends StatefulWidget {
  const EnhancedCommentTile({
    super.key,
    required this.user,
    required this.comment,
    required this.timestamp,
  });

  final String user;
  final String comment;
  final String timestamp;

  @override
  State<EnhancedCommentTile> createState() => _EnhancedCommentTileState();
}

class _EnhancedCommentTileState extends State<EnhancedCommentTile>
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
    likeCount = (1 + (widget.comment.hashCode % 10)).abs();
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
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColor.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
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
                            radius: 18,
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
                            width: 10,
                            height: 10,
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
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.timestamp,
                            style: TextStyle(
                              color: TColor.onSurfaceVariant,
                              fontSize: 12,
                            ),
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
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Comment Content
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TColor.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: TColor.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.comment,
                    style: TextStyle(
                      color: TColor.onSurface,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Engagement Section
                Row(
                  children: [
                    // Like Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                          likeCount += isLiked ? 1 : -1;
                        });
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isLiked
                              ? TColor.error.withOpacity(0.1)
                              : TColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isLiked ? TColor.error : TColor.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              likeCount.toString(),
                              style: TextStyle(
                                color: isLiked ? TColor.error : TColor.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Reply Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: TColor.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.reply_rounded,
                            color: TColor.secondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Reply",
                            style: TextStyle(
                              color: TColor.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
