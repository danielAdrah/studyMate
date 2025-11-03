import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/study_session_card.dart';
import '../../model/study_session.dart';
import '../../services/study_group_service.dart';
import '../../theme.dart';
import 'create_study_session.dart';

class StudySessionsView extends StatefulWidget {
  final String groupId;
  final String groupName;

  const StudySessionsView({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<StudySessionsView> createState() => _StudySessionsViewState();
}

class _StudySessionsViewState extends State<StudySessionsView> {
  final studyGroupService = StudyGroupService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        title: Text("${widget.groupName} Sessions"),
        backgroundColor: TColor.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.onSurface),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: TColor.primary),
            onPressed: () {
              Get.to(() => CreateStudySession(groupId: widget.groupId));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Upcoming Sessions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Sessions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.onSurface,
                  ),
                ),
                Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    color: TColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sessions List
            Expanded(
              child: StreamBuilder<List<StudySession>>(
                stream: studyGroupService.getGroupSessions(widget.groupId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final sessions = snapshot.data ?? [];

                  if (sessions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 60,
                            color: TColor.primary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No Sessions Yet",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: TColor.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Create a study session to get started",
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

                  return ListView.separated(
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isUpcoming =
                          session.endTime.toDate().isAfter(DateTime.now());

                      return StudySessionCard(
                        title: session.title,
                        startTime: session.startTime.toDate(),
                        endTime: session.endTime.toDate(),
                        participantCount: session.participantIds.length,
                        onTap: () {
                          // View session details
                          // Could navigate to a session detail page
                        },
                        isUpcoming: isUpcoming,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
