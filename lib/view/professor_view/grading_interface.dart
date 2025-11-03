import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../model/assignment.dart';
import '../../model/submission.dart';
import '../../model/grade.dart';
import '../../services/assignment_service.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_button.dart';
import '../../theme.dart';

class GradingInterface extends StatefulWidget {
  final Assignment assignment;

  const GradingInterface({super.key, required this.assignment});

  @override
  State<GradingInterface> createState() => _GradingInterfaceState();
}

class _GradingInterfaceState extends State<GradingInterface>
    with TickerProviderStateMixin {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              "Grading: ${widget.assignment.title}",
              style: TextStyle(
                color: TColor.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.assignment.courseName,
              style: TextStyle(
                color: TColor.onPrimary.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
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
          _buildGradingStats(),
          Container(
            decoration: BoxDecoration(
              color: TColor.surface,
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: TColor.primary,
              unselectedLabelColor: TColor.onSurfaceVariant,
              indicatorColor: TColor.primary,
              indicatorWeight: 3,
              // indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              tabs: const [
                Tab(
                  text: "Pending",
                  icon: Icon(Icons.pending_actions_rounded),
                ),
                Tab(
                  text: "Graded",
                  icon: Icon(Icons.check_circle_rounded),
                ),
                Tab(
                  text: "All",
                  icon: Icon(Icons.list_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingSubmissions(),
                _buildGradedSubmissions(),
                _buildAllSubmissions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradingStats() {
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
      child: StreamBuilder<List<Submission>>(
        stream:
            _assignmentService.getAssignmentSubmissions(widget.assignment.id),
        builder: (context, snapshot) {
          final submissions = snapshot.data ?? [];
          final gradedCount = submissions.where((s) => s.isGraded).length;
          final progress =
              submissions.isNotEmpty ? gradedCount / submissions.length : 0.0;

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Total Submissions",
                      submissions.length.toString(),
                      Icons.assignment_turned_in_rounded,
                      TColor.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Graded",
                      gradedCount.toString(),
                      Icons.grade_rounded,
                      TColor.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Pending",
                      (submissions.length - gradedCount).toString(),
                      Icons.pending_rounded,
                      TColor.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColor.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          Icon(Icons.timeline_rounded, color: TColor.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Progress:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: TColor.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: TColor.onSurfaceVariant.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  progress == 1.0
                                      ? TColor.success
                                      : TColor.primary,
                                  progress == 1.0
                                      ? TColor.success
                                      : TColor.accent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            progress == 1.0 ? TColor.success : TColor.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${(progress * 100).toInt()}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: TColor.onPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
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

  Widget _buildPendingSubmissions() {
    return StreamBuilder<List<Submission>>(
      stream: _assignmentService.getAssignmentSubmissions(widget.assignment.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final pendingSubmissions = (snapshot.data ?? [])
            .where((s) => s.isSubmitted && !s.isGraded)
            .toList();

        if (pendingSubmissions.isEmpty) {
          return _buildEmptyState(
            "No pending submissions",
            "All submissions have been graded!",
            Icons.check_circle_outline,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pendingSubmissions.length,
          itemBuilder: (context, index) => _buildSubmissionCard(
            pendingSubmissions[index],
            isPending: true,
          ),
        );
      },
    );
  }

  Widget _buildGradedSubmissions() {
    return StreamBuilder<List<Submission>>(
      stream: _assignmentService.getAssignmentSubmissions(widget.assignment.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final gradedSubmissions =
            (snapshot.data ?? []).where((s) => s.isGraded).toList();

        if (gradedSubmissions.isEmpty) {
          return _buildEmptyState(
            "No graded submissions",
            "Grade submissions to see them here",
            Icons.grade,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: gradedSubmissions.length,
          itemBuilder: (context, index) => _buildSubmissionCard(
            gradedSubmissions[index],
            isPending: false,
          ),
        );
      },
    );
  }

  Widget _buildAllSubmissions() {
    return StreamBuilder<List<Submission>>(
      stream: _assignmentService.getAssignmentSubmissions(widget.assignment.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final submissions =
            (snapshot.data ?? []).where((s) => s.isSubmitted).toList();

        if (submissions.isEmpty) {
          return _buildEmptyState(
            "No submissions yet",
            "Students haven't submitted any work yet",
            Icons.assignment,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: submissions.length,
          itemBuilder: (context, index) => _buildSubmissionCard(
            submissions[index],
            isPending: !submissions[index].isGraded,
          ),
        );
      },
    );
  }

  Widget _buildSubmissionCard(Submission submission,
      {required bool isPending}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: TColor.surface,
      child: InkWell(
        onTap: () => _openGradingDialog(submission),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: TColor.primary,
                    child: Text(
                      submission.studentName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: TColor.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          submission.studentName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: TColor.onSurface,
                          ),
                        ),
                        Text(
                          submission.studentEmail,
                          style: TextStyle(
                            color: TColor.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPending)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TColor.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "PENDING",
                        style: TextStyle(
                          color: TColor.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TColor.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        submission.gradeDisplayText,
                        style: TextStyle(
                          color: TColor.success,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: TColor.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    "Submitted: ${DateFormat('MMM dd, HH:mm').format(submission.submittedAt!)}",
                    style:
                        TextStyle(color: TColor.onSurfaceVariant, fontSize: 12),
                  ),
                  const Spacer(),
                  if (submission.isLateSubmission)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: TColor.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "LATE",
                        style: TextStyle(
                          color: TColor.error,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.quiz, size: 14, color: TColor.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    "${submission.answeredQuestions}/${widget.assignment.questions.length} questions answered",
                    style:
                        TextStyle(color: TColor.onSurfaceVariant, fontSize: 12),
                  ),
                  const Spacer(),
                  if (!isPending && submission.scorePercentage != null)
                    Text(
                      "${submission.scorePercentage!.toStringAsFixed(1)}%",
                      style: TextStyle(
                        color: submission.scorePercentage! >= 70
                            ? TColor.success
                            : TColor.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: TColor.onSurfaceVariant.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: TColor.onSurfaceVariant.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  void _openGradingDialog(Submission submission) {
    showDialog(
      context: context,
      builder: (context) => GradingDialog(
        assignment: widget.assignment,
        submission: submission,
        onGradeSubmitted: () => setState(() {}),
      ),
    );
  }
}

class GradingDialog extends StatefulWidget {
  final Assignment assignment;
  final Submission submission;
  final VoidCallback onGradeSubmitted;

  const GradingDialog({
    super.key,
    required this.assignment,
    required this.submission,
    required this.onGradeSubmitted,
  });

  @override
  State<GradingDialog> createState() => _GradingDialogState();
}

class _GradingDialogState extends State<GradingDialog> {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  final TextEditingController _feedbackController = TextEditingController();
  final List<TextEditingController> _questionFeedbackControllers = [];
  final List<TextEditingController> _pointsControllers = [];

  bool _isLoading = false;
  Grade? _existingGrade;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingGrade();
  }

  void _initializeControllers() {
    for (final question in widget.assignment.questions) {
      _questionFeedbackControllers.add(TextEditingController());
      _pointsControllers
          .add(TextEditingController(text: question.maxPoints.toString()));
    }
  }

  Future<void> _loadExistingGrade() async {
    final grade =
        await _assignmentService.getGradeForSubmission(widget.submission.id);
    if (grade != null) {
      setState(() {
        _existingGrade = grade;
        _feedbackController.text = grade.overallFeedback ?? '';

        for (int i = 0;
            i < grade.questionGrades.length && i < _pointsControllers.length;
            i++) {
          final questionGrade = grade.questionGrades[i];
          _pointsControllers[i].text = questionGrade.pointsEarned.toString();
          _questionFeedbackControllers[i].text = questionGrade.feedback ?? '';
        }
      });
    } else {
      // Auto-grade multiple choice questions
      _autoGradeMultipleChoice();
    }
  }

  void _autoGradeMultipleChoice() {
    for (int i = 0; i < widget.assignment.questions.length; i++) {
      final question = widget.assignment.questions[i];
      if (question.type == AssignmentType.multipleChoice &&
          question.correctAnswer != null &&
          i < widget.submission.answers.length) {
        final answer = widget.submission.answers[i];
        if (answer.selectedOption == question.correctAnswer) {
          _pointsControllers[i].text = question.maxPoints.toString();
        } else {
          _pointsControllers[i].text = "0";
        }
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    for (final controller in _questionFeedbackControllers) {
      controller.dispose();
    }
    for (final controller in _pointsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TColor.surface,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStudentInfo(),
                    const SizedBox(height: 16),
                    _buildQuestionGrading(),
                    const SizedBox(height: 16),
                    _buildOverallFeedback(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Grading Submission",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TColor.onSurface,
                ),
              ),
              Text(
                widget.assignment.title,
                style: TextStyle(color: TColor.onSurfaceVariant, fontSize: 14),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildStudentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: TColor.primary,
            child: Text(
              widget.submission.studentName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                  color: TColor.onPrimary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.submission.studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TColor.onSurface,
                  ),
                ),
                Text(
                  widget.submission.studentEmail,
                  style:
                      TextStyle(color: TColor.onSurfaceVariant, fontSize: 12),
                ),
                Text(
                  "Submitted: ${DateFormat('MMM dd, yyyy HH:mm').format(widget.submission.submittedAt!)}",
                  style:
                      TextStyle(color: TColor.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          if (widget.submission.isLateSubmission)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TColor.error.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "LATE",
                style: TextStyle(
                  color: TColor.error,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionGrading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Questions & Answers",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: TColor.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.assignment.questions.length,
          itemBuilder: (context, index) => _buildQuestionGradeCard(index),
        ),
      ],
    );
  }

  Widget _buildQuestionGradeCard(int index) {
    final question = widget.assignment.questions[index];
    final answer = index < widget.submission.answers.length
        ? widget.submission.answers[index]
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: TColor.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: TColor.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColor.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _pointsControllers[index],
                    decoration: InputDecoration(
                      labelText: "/${question.maxPoints}",
                      labelStyle: TextStyle(color: TColor.onSurfaceVariant),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: TColor.onSurfaceVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: TColor.primary),
                      ),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColor.onSurfaceVariant.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Student Answer:",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: TColor.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAnswerText(question, answer),
                    style: TextStyle(fontSize: 14, color: TColor.onSurface),
                  ),
                  if (question.type == AssignmentType.multipleChoice &&
                      question.correctAnswer != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          answer?.selectedOption == question.correctAnswer
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                              answer?.selectedOption == question.correctAnswer
                                  ? TColor.success
                                  : TColor.error,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Correct answer: ${question.correctAnswer}",
                          style: TextStyle(
                            color: TColor.onSurfaceVariant,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _questionFeedbackControllers[index],
              style: TextStyle(color: TColor.onSurface),
              decoration: InputDecoration(
                labelText: "Feedback (optional)",
                labelStyle: TextStyle(color: TColor.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: TColor.onSurfaceVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: TColor.primary),
                ),
                isDense: true,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Overall Feedback",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: TColor.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _feedbackController,
          style: TextStyle(color: TColor.onSurface),
          decoration: InputDecoration(
            hintText: "Provide overall feedback for the student...",
            hintStyle: TextStyle(color: TColor.onSurfaceVariant),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: TColor.onSurfaceVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: TColor.primary),
            ),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final totalPoints = _calculateTotalPoints();
    final maxPoints = widget.assignment.totalPoints.toDouble();
    final percentage = maxPoints > 0 ? (totalPoints / maxPoints) * 100 : 0.0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColor.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text("Total Score: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TColor.onSurface,
                  )),
              Text(
                "${totalPoints.toStringAsFixed(1)}/${maxPoints.toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: percentage >= 70 ? TColor.success : TColor.error,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            CustomButton(
              title: _existingGrade != null ? "Update Grade" : "Submit Grade",
              // onTap: _isLoading ? () {} : () => _submitGrade(),
              onTap: () => _submitGrade(),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: TColor.onSurfaceVariant,
                side: BorderSide(color: TColor.onSurfaceVariant),
              ),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }

  String _getAnswerText(Question question, Answer? answer) {
    if (answer == null || !answer.hasAnswer) {
      return "No answer provided";
    }

    switch (question.type) {
      case AssignmentType.multipleChoice:
        return answer.selectedOption ?? "No selection";
      case AssignmentType.shortAnswer:
      case AssignmentType.essay:
        return answer.textAnswer ?? "No text provided";
      case AssignmentType.survey:
        if (answer.rating != null) {
          return "Rating: ${answer.rating}/5";
        }
        return answer.textAnswer ?? "No response";
      case AssignmentType.quiz:
        return answer.selectedOption ?? answer.textAnswer ?? "No answer";
    }
  }

  double _calculateTotalPoints() {
    double total = 0.0;
    for (final controller in _pointsControllers) {
      total += double.tryParse(controller.text) ?? 0.0;
    }
    return total;
  }

  Future<void> _submitGrade() async {
    setState(() => _isLoading = true);

    try {
      final questionGrades = <QuestionGrade>[];

      for (int i = 0; i < widget.assignment.questions.length; i++) {
        final question = widget.assignment.questions[i];
        final points = double.tryParse(_pointsControllers[i].text) ?? 0.0;

        questionGrades.add(
          QuestionGrade(
            questionId: question.id,
            pointsEarned: points,
            maxPoints: question.maxPoints.toDouble(),
            feedback: _questionFeedbackControllers[i].text.trim().isEmpty
                ? null
                : _questionFeedbackControllers[i].text.trim(),
            gradeType: question.type == AssignmentType.multipleChoice
                ? GradeType.automatic
                : GradeType.manual,
            gradedAt: DateTime.now(),
          ),
        );
      }

      final grade = Grade(
        id: _existingGrade?.id ?? const Uuid().v4(),
        submissionId: widget.submission.id,
        assignmentId: widget.assignment.id,
        studentId: widget.submission.studentId,
        studentName: widget.submission.studentName,
        professorId: widget.assignment.professorId,
        professorName: widget.assignment.professorName,
        questionGrades: questionGrades,
        totalScore: _calculateTotalPoints(),
        maxScore: widget.assignment.totalPoints.toDouble(),
        overallFeedback: _feedbackController.text.trim().isEmpty
            ? null
            : _feedbackController.text.trim(),
        gradedAt: DateTime.now(),
      );

      if (_existingGrade != null) {
        await _assignmentService.updateGrade(grade);
        Get.snackbar("Success", "Grade updated successfully",
            backgroundColor: TColor.success, colorText: Colors.white);
      } else {
        await _assignmentService.createGrade(grade);
        Get.snackbar("Success", "Grade submitted successfully",
            backgroundColor: TColor.success, colorText: Colors.white);
      }

      widget.onGradeSubmitted();
      Navigator.pop(context);
    } catch (e) {
      Get.snackbar("Error", "Failed to submit grade: $e",
          colorText: Colors.white, backgroundColor: TColor.error);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
