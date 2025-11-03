// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/assignment.dart';
import '../../services/assignment_service.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../theme.dart';

class ProfessorAnalytics extends StatefulWidget {
  const ProfessorAnalytics({super.key});

  @override
  State<ProfessorAnalytics> createState() => _ProfessorAnalyticsState();
}

class _ProfessorAnalyticsState extends State<ProfessorAnalytics>
    with TickerProviderStateMixin {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  late TabController _tabController;
  String? professorId;

  Map<String, dynamic>? _overallStats;
  List<Assignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Get professor ID from Firebase Auth
    professorId = FirebaseAuth.instance.currentUser?.uid;

    if (professorId == null) {
      // Handle case where user is not authenticated
      Get.snackbar("Error", "User not authenticated");
      Get.back();
    } else {
      _loadData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final stats = await _assignmentService.getProfessorStats(professorId!);
      setState(() {
        _overallStats = stats;
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to load analytics: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: TColor.primary,
        foregroundColor: TColor.onPrimary,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "Analytics Dashboard",
              style: TextStyle(
                color: TColor.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "Assignment Performance Insights",
              style: TextStyle(
                color: TColor.onPrimary.withOpacity(0.8),
                fontSize: 12,
              ),
            )
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TColor.primary,
                TColor.secondary,
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildOverallStats(),
          Container(
            color: TColor.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: TColor.primary,
              unselectedLabelColor: TColor.onSurfaceVariant,
              indicatorColor: TColor.primary,
              indicatorWeight: 3,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  text: "Overview",
                  icon: Icon(Icons.dashboard_rounded),
                ),
                Tab(
                  text: "Performance",
                  icon: Icon(Icons.trending_up_rounded),
                ),
                Tab(
                  text: "Detailed",
                  icon: Icon(Icons.analytics_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildPerformanceTab(),
                _buildDetailedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStats() {
    if (_overallStats == null) {
      return Container(
        height: 140,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColor.primary.withOpacity(0.1),
              TColor.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColor.primary.withOpacity(0.1),
            TColor.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              "Total Assignments",
              _overallStats!['totalAssignments'].toString(),
              Icons.assignment_rounded,
              TColor.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              "Published",
              _overallStats!['publishedAssignments'].toString(),
              Icons.publish_rounded,
              TColor.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              "Submissions",
              _overallStats!['totalSubmissions'].toString(),
              Icons.assignment_turned_in_rounded,
              TColor.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              "Pending Grading",
              _overallStats!['pendingGrading'].toString(),
              Icons.pending_actions_rounded,
              TColor.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColor.surface,
            color.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: TColor.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickInsights(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
          const SizedBox(height: 24),
          _buildWorkloadSummary(),
        ],
      ),
    );
  }

  Widget _buildQuickInsights() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.insights_rounded,
                    color: TColor.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Quick Insights",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_overallStats != null) ...[
              _buildInsightRow(
                "Grading Efficiency",
                "${(((_overallStats!['totalGraded'] ?? 0) / (_overallStats!['totalSubmissions'] == 0 ? 1 : _overallStats!['totalSubmissions'])) * 100).toInt()}%",
                Icons.speed_rounded,
                TColor.primary,
              ),
              const SizedBox(height: 16),
              _buildInsightRow(
                "Active Assignments",
                _overallStats!['publishedAssignments'].toString(),
                Icons.trending_up_rounded,
                TColor.success,
              ),
              const SizedBox(height: 16),
              _buildInsightRow(
                "Pending Tasks",
                _overallStats!['pendingGrading'].toString(),
                Icons.hourglass_empty_rounded,
                TColor.warning,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: TColor.onSurface,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: TColor.onPrimary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColor.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: TColor.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Recent Activity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<Assignment>>(
              stream: _assignmentService.getProfessorAssignments(professorId!),
              builder: (context, snapshot) {
                final assignments = (snapshot.data ?? []).take(5).toList();

                if (assignments.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: TColor.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: TColor.onSurfaceVariant.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 48,
                            color: TColor.onSurfaceVariant.withOpacity(0.6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No recent activity",
                            style: TextStyle(color: TColor.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: assignments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final assignment = entry.value;
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: index < assignments.length - 1 ? 16 : 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TColor.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _getStatusColor(assignment.status)
                                .withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getStatusColor(assignment.status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getStatusIcon(assignment.status),
                              size: 20,
                              color: _getStatusColor(assignment.status),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  assignment.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: TColor.onSurface,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${assignment.courseName} • ${assignment.statusDisplayText}",
                                  style: TextStyle(
                                    color: TColor.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: TColor.onSurfaceVariant.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              DateFormat('MMM dd').format(assignment.createdAt),
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkloadSummary() {
    return Card(
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Workload Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Assignment>>(
              stream: _assignmentService.getProfessorAssignments(professorId!),
              builder: (context, snapshot) {
                final assignments = snapshot.data ?? [];

                final upcomingDueDates = assignments
                    .where((a) =>
                        a.dueDate.isAfter(DateTime.now()) &&
                        a.status == AssignmentStatus.published)
                    .toList()
                  ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

                if (upcomingDueDates.isEmpty) {
                  return Text(
                    "No upcoming deadlines",
                    style: TextStyle(color: TColor.onSurfaceVariant),
                  );
                }

                return Column(
                  children: upcomingDueDates.take(3).map((assignment) {
                    final daysUntilDue =
                        assignment.dueDate.difference(DateTime.now()).inDays;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: daysUntilDue <= 1
                            ? TColor.error.withOpacity(0.1)
                            : TColor.onSurfaceVariant.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: daysUntilDue <= 1
                              ? TColor.error.withOpacity(0.3)
                              : TColor.onSurfaceVariant.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: daysUntilDue <= 1
                                ? TColor.error
                                : TColor.onSurfaceVariant,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  assignment.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: TColor.onSurface,
                                  ),
                                ),
                                Text(
                                  "Due: ${DateFormat('MMM dd, HH:mm').format(assignment.dueDate)}",
                                  style: TextStyle(
                                    color: TColor.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: daysUntilDue <= 1
                                  ? TColor.error
                                  : TColor.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              daysUntilDue <= 0 ? "Today" : "${daysUntilDue}d",
                              style: TextStyle(
                                color: TColor.onPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getProfessorAssignments(professorId!),
      builder: (context, snapshot) {
        final assignments = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPerformanceMetrics(assignments),
              const SizedBox(height: 24),
              _buildGradingProgress(assignments),
              const SizedBox(height: 24),
              _buildSubmissionTrends(assignments),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceMetrics(List<Assignment> assignments) {
    final publishedAssignments =
        assignments.where((a) => a.isPublished).toList();
    final totalSubmissions =
        publishedAssignments.fold(0, (sum, a) => sum + a.submissionCount);
    final totalGraded =
        publishedAssignments.fold(0, (sum, a) => sum + a.gradedCount);
    final averageSubmissions = publishedAssignments.isNotEmpty
        ? totalSubmissions / publishedAssignments.length
        : 0.0;

    return Card(
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Performance Metrics",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    "Avg Submissions",
                    averageSubmissions.toStringAsFixed(1),
                    "per assignment",
                    TColor.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    "Grading Rate",
                    totalSubmissions > 0
                        ? "${((totalGraded / totalSubmissions) * 100).toInt()}%"
                        : "0%",
                    "completed",
                    TColor.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: TColor.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: TColor.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradingProgress(List<Assignment> assignments) {
    final needsGrading = assignments
        .where((a) => a.submissionCount > a.gradedCount)
        .toList()
      ..sort((a, b) => (b.submissionCount - b.gradedCount)
          .compareTo(a.submissionCount - a.gradedCount));

    return Card(
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Grading Progress",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            if (needsGrading.isEmpty)
              Text(
                "All assignments are fully graded! 🎉",
                style: TextStyle(color: TColor.onSurfaceVariant),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: needsGrading.length,
                itemBuilder: (context, index) {
                  final assignment = needsGrading[index];
                  final pending =
                      assignment.submissionCount - assignment.gradedCount;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                assignment.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: TColor.onSurface,
                                ),
                              ),
                            ),
                            Text(
                              "${assignment.gradedCount}/${assignment.submissionCount}",
                              style: TextStyle(
                                color: TColor.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: assignment.gradingProgress,
                          backgroundColor:
                              TColor.onSurfaceVariant.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            assignment.gradingProgress == 1.0
                                ? TColor.success
                                : TColor.warning,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$pending pending submissions",
                          style: TextStyle(
                            color: TColor.warning,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionTrends(List<Assignment> assignments) {
    return Card(
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Submission Trends",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            if (assignments.isEmpty)
              Text(
                "No data available",
                style: TextStyle(color: TColor.onSurfaceVariant),
              )
            else
              _buildSimpleChart(assignments),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleChart(List<Assignment> assignments) {
    final publishedAssignments = assignments
        .where((a) => a.isPublished)
        .toList()
      ..sort((a, b) => a.publishedAt!.compareTo(b.publishedAt!));

    if (publishedAssignments.isEmpty) {
      return Text(
        "No published assignments yet",
        style: TextStyle(color: TColor.onSurfaceVariant),
      );
    }

    return Column(
      children: publishedAssignments.take(5).map((assignment) {
        final maxSubmissions = publishedAssignments
            .map((a) => a.submissionCount)
            .reduce((a, b) => a > b ? a : b);

        final normalizedValue = maxSubmissions > 0
            ? assignment.submissionCount / maxSubmissions
            : 0.0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: TColor.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    assignment.submissionCount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: TColor.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: TColor.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: normalizedValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailedTab() {
    return StreamBuilder<List<Assignment>>(
      stream: _assignmentService.getProfessorAssignments(professorId!),
      builder: (context, snapshot) {
        final assignments = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) =>
              _buildDetailedAssignmentCard(assignments[index]),
        );
      },
    );
  }

  Widget _buildDetailedAssignmentCard(Assignment assignment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: TColor.surface,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(assignment.status),
          radius: 20,
          child: Icon(
            _getStatusIcon(assignment.status),
            color: Colors.white,
            size: 16,
          ),
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: TColor.onSurface,
          ),
        ),
        subtitle: Text(
          "${assignment.courseName} • ${assignment.statusDisplayText}",
          style: TextStyle(color: TColor.onSurfaceVariant),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow("Created",
                    DateFormat('MMM dd, yyyy').format(assignment.createdAt)),
                _buildDetailRow(
                    "Due Date",
                    DateFormat('MMM dd, yyyy HH:mm')
                        .format(assignment.dueDate)),
                _buildDetailRow(
                    "Total Points", assignment.totalPoints.toString()),
                _buildDetailRow(
                    "Questions", assignment.questions.length.toString()),
                if (assignment.isPublished) ...[
                  _buildDetailRow(
                      "Submissions", assignment.submissionCount.toString()),
                  _buildDetailRow("Graded", assignment.gradedCount.toString()),
                  _buildDetailRow("Progress",
                      "${(assignment.gradingProgress * 100).toInt()}%"),
                ],
                if (assignment.isOverdue)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: TColor.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "OVERDUE",
                      style: TextStyle(
                        color: TColor.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: TColor.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: TColor.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.draft:
        return TColor.onSurfaceVariant;
      case AssignmentStatus.published:
        return TColor.success;
      case AssignmentStatus.closed:
        return TColor.primary;
      case AssignmentStatus.graded:
        return TColor.secondary;
    }
  }

  IconData _getStatusIcon(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.draft:
        return Icons.drafts;
      case AssignmentStatus.published:
        return Icons.publish;
      case AssignmentStatus.closed:
        return Icons.lock;
      case AssignmentStatus.graded:
        return Icons.grade;
    }
  }
}
