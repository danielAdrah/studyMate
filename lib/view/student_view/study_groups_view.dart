import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/study_group_card.dart';
import '../../common_widgets/study_session_card.dart';
import '../../model/study_group.dart';
import '../../model/study_session.dart';
import '../../services/notification_service.dart';
import '../../services/study_group_service.dart';
import 'create_study_group.dart';
import 'study_sessions_view.dart';
import 'study_group_detail.dart';
import '../../theme.dart';

class StudyGroupsView extends StatefulWidget {
  const StudyGroupsView({super.key});

  @override
  State<StudyGroupsView> createState() => _StudyGroupsViewState();
}

class _StudyGroupsViewState extends State<StudyGroupsView> {
  final studyGroupService = StudyGroupService();
  final notiService = NotificationService();
  List<String> favoriteGroupIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: TColor.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    FadeInDown(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        "Study Groups",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: TColor.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeInDown(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        "Collaborate with classmates on your courses",
                        style: TextStyle(
                          fontSize: 16,
                          color: TColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Create Group Button
                  FadeInDown(
                    delay: const Duration(milliseconds: 500),
                    child: _buildCreateGroupButton(),
                  ),
                  const SizedBox(height: 30),

                  // My Groups Section
                  FadeInDown(
                    delay: const Duration(milliseconds: 600),
                    child: _buildSectionHeader(
                        "My Study Groups", "Groups you created or joined"),
                  ),
                  const SizedBox(height: 20),
                  FadeInDown(
                    delay: const Duration(milliseconds: 700),
                    child: _buildMyGroupsList(),
                  ),
                  const SizedBox(height: 40),

                  // Discover Groups Section
                  FadeInDown(
                    delay: const Duration(milliseconds: 800),
                    child: _buildSectionHeader(
                        "Discover Groups", "Join groups created by classmates"),
                  ),
                  const SizedBox(height: 20),
                  FadeInDown(
                    delay: const Duration(milliseconds: 900),
                    child: _buildDiscoverableGroups(),
                  ),
                  const SizedBox(height: 40),
                  Divider(
                    color: TColor.primary.withOpacity(0.1),
                    indent: 20,
                    endIndent: 20,
                  ),

                  // My Sessions Section
                  FadeInDown(
                    delay: const Duration(milliseconds: 1000),
                    child: _buildSectionHeader(
                        "My Sessions", "Sessions you created or joined"),
                  ),
                  const SizedBox(height: 20),
                  FadeInDown(
                    delay: const Duration(milliseconds: 1100),
                    child: _buildMySessionsList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: TColor.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: TColor.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateGroupButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColor.primary, TColor.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to group creation screen
          Get.to(const CreateStudyGroup());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: TColor.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "Create New Study Group",
              style: TextStyle(
                color: TColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyGroupsList() {
    return StreamBuilder<List<StudyGroup>>(
      stream: studyGroupService.getUserStudyGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final groups = snapshot.data ?? [];

        if (groups.isEmpty) {
          return _buildEmptyState(
            icon: Icons.groups,
            title: "No Study Groups Yet",
            message:
                "Create or join a study group to get started with collaborative learning",
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groups.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final group = groups[index];
            final isFavorite = favoriteGroupIds.contains(group.id);

            return StudyGroupCard(
              groupName: group.name,
              courseName: group.courseName,
              memberCount: group.memberIds.length,
              onTap: () {
                // Navigate to group detail page
                Get.to(() => StudyGroupDetail(group: group));
              },
              isFavorite: isFavorite,
              onFavoriteToggle: () {
                setState(() {
                  if (isFavorite) {
                    favoriteGroupIds.remove(group.id);
                  } else {
                    favoriteGroupIds.add(group.id);
                  }
                });
              },
              joinButtonVisible: false,
              onJoinPressed: () {},
            );
          },
        );
      },
    );
  }

  Widget _buildDiscoverableGroups() {
    return StreamBuilder<List<StudyGroup>>(
      stream: studyGroupService.getAllStudyGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final allGroups = snapshot.data ?? [];
        final currentUserID = studyGroupService.auth.currentUser!.uid;
        final discoverableGroups = allGroups.where((group) {
          return !group.memberIds.contains(currentUserID);
        }).toList();

        if (discoverableGroups.isEmpty) {
          return _buildEmptyState(
            icon: Icons.search,
            title: "No Groups to Discover",
            message: "All available groups have been joined",
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: discoverableGroups.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final group = discoverableGroups[index];
            final isFavorite = favoriteGroupIds.contains(group.id);

            return StudyGroupCard(
              groupName: group.name,
              courseName: group.courseName,
              memberCount: group.memberIds.length,
              onTap: () {
                // Navigate to group detail page
                Get.to(() => StudyGroupDetail(group: group));
              },
              isFavorite: isFavorite,
              onFavoriteToggle: () {
                setState(() {
                  if (isFavorite) {
                    favoriteGroupIds.remove(group.id);
                  } else {
                    favoriteGroupIds.add(group.id);
                  }
                });
              },
              joinButtonVisible: true,
              onJoinPressed: () async {
                try {
                  await studyGroupService.joinStudyGroup(group.id);

                  // Show success message
                  Get.snackbar(
                    "Success",
                    "Joined ${group.name}!",
                    backgroundColor: TColor.success,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  // Refresh the list by rebuilding the widget
                  setState(() {});
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Failed to join group: ${e.toString()}",
                    backgroundColor: TColor.error,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMySessionsList() {
    final currentUserID = studyGroupService.auth.currentUser!.uid;

    return StreamBuilder<List<StudySession>>(
      stream: studyGroupService.getAllSessions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final allSessions = snapshot.data ?? [];
        final userSessions = allSessions.where((session) {
          return session.participantIds.contains(currentUserID);
        }).toList();

        if (userSessions.isEmpty) {
          return _buildEmptyState(
            icon: Icons.calendar_today,
            title: "No Sessions Yet",
            message: "You haven't joined any study sessions yet",
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userSessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final session = userSessions[index];
            final isUpcoming = session.endTime.toDate().isAfter(DateTime.now());

            return StudySessionCard(
              title: session.title,
              startTime: session.startTime.toDate(),
              endTime: session.endTime.toDate(),
              participantCount: session.participantIds.length,
              onTap: () {
                // Navigate to sessions view for all sessions
                Get.to(() => StudySessionsView(
                    groupId: session.groupId, groupName: 'Study Session'));
              },
              isUpcoming: isUpcoming,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: TColor.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: TColor.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
