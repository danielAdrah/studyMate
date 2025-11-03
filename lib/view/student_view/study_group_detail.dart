import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../common_widgets/study_group_message_bubble.dart';
import '../../services/study_group_service.dart';
import '../../model/study_group.dart';
import '../../model/study_group_message.dart';
import '../../theme.dart';
import 'create_study_session.dart';
import 'study_sessions_view.dart';

class StudyGroupDetail extends StatefulWidget {
  final StudyGroup group;

  const StudyGroupDetail({
    super.key,
    required this.group,
  });

  @override
  State<StudyGroupDetail> createState() => _StudyGroupDetailState();
}

class _StudyGroupDetailState extends State<StudyGroupDetail>
    with TickerProviderStateMixin {
  final studyGroupService = StudyGroupService();
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await studyGroupService.sendGroupMessage(
        widget.group.id,
        messageController.text,
      );
      messageController.clear();
      scrollDown();
    }
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.onSurface,
              ),
            ),
            Text(
              widget.group.courseName,
              style: TextStyle(
                fontSize: 14,
                color: TColor.primary,
              ),
            ),
          ],
        ),
        backgroundColor: TColor.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.onSurface),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: TColor.primary),
            onPressed: () {
              Get.to(() => CreateStudySession(groupId: widget.group.id));
            },
          ),
          IconButton(
            icon: Icon(Icons.event_note, color: TColor.primary),
            onPressed: () {
              Get.to(() => StudySessionsView(
                    groupId: widget.group.id,
                    groupName: widget.group.name,
                  ));
            },
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: TColor.primary,
          labelColor: TColor.primary,
          unselectedLabelColor: TColor.onSurfaceVariant,
          tabs: const [
            Tab(text: "Chat"),
            Tab(text: "Info"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildChatTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: _buildMessageList(),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TColor.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TColor.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.groups, color: TColor.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      "Group Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColor.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow("Course", widget.group.courseName),
                const SizedBox(height: 8),
                _buildInfoRow("Members", "${widget.group.memberIds.length}"),
                const SizedBox(height: 8),
                _buildInfoRow("Created",
                    widget.group.createdAt.toDate().toString().split(' ')[0]),
                if (widget.group.description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TColor.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.group.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: TColor.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: TColor.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TColor.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.background,
      ),
      child: StreamBuilder<List<StudyGroupMessage>>(
        stream: studyGroupService.getGroupMessages(widget.group.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final messages = snapshot.data ?? [];

          if (messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 60,
                    color: TColor.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No messages yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TColor.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Start the conversation!",
                    style: TextStyle(
                      fontSize: 14,
                      color: TColor.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final message = messages[index];
              final isCurrentUser =
                  message.senderID == studyGroupService.auth.currentUser!.uid;

              return FadeInUp(
                delay: Duration(milliseconds: 100 * index),
                child: StudyGroupMessageBubble(
                  message: message.message,
                  senderName: message.senderEmail, // Use email prefix as name
                  timestamp: message.timestamp.toDate(),
                  isCurrentUser: isCurrentUser,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TColor.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: TColor.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: TColor.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: messageController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: TColor.onSurface,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(
                    color: TColor.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColor.primary, TColor.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.send_rounded,
                    color: TColor.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
