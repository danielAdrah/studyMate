import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../model/assignment.dart';
import '../../model/submission.dart';
import '../../services/assignment_service.dart';
import '../../theme.dart';

class AssignmentDetailView extends StatefulWidget {
  final Assignment assignment;

  const AssignmentDetailView({super.key, required this.assignment});

  @override
  State<AssignmentDetailView> createState() => _AssignmentDetailViewState();
}

class _AssignmentDetailViewState extends State<AssignmentDetailView> {
  final AssignmentService _assignmentService = Get.find<AssignmentService>();
  final List<TextEditingController> _answerControllers = [];
  final List<String> _selectedOptions = [];
  bool _isLoading = false;
  Submission? _existingSubmission;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingSubmission();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.assignment.questions.length; i++) {
      _answerControllers.add(TextEditingController());
      _selectedOptions.add("");
    }
  }

  Future<void> _loadExistingSubmission() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // In a real implementation, you would fetch the existing submission
    // For now, we'll leave _existingSubmission as null
  }

  Future<String> _getStudentName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['name'] ?? 'Unknown Student';
      } else {
        return 'Unknown Student';
      }
    } catch (e) {
      print('Error getting student name: $e');
      return 'Unknown Student';
    }
  }

  @override
  void dispose() {
    for (final controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            backgroundColor: TColor.background,
            elevation: 0,
            pinned: true,
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
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: TColor.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: TColor.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.assignment_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.assignment.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: TColor.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.assignment.courseName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: TColor.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInDown(
                      delay: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColor.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TColor.navBarBackground,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoItem(
                              Icons.schedule,
                              "Due: ${DateFormat('MMM dd, yyyy HH:mm').format(widget.assignment.dueDate)}",
                              TColor.warning,
                            ),
                            // const SizedBox(width: 10),
                            _buildInfoItem(
                              Icons.bar_chart,
                              "${widget.assignment.totalPoints} points",
                              TColor.primary,
                            ),
                            // const SizedBox(width: 10),
                            // _buildInfoItem(
                            //   Icons.question_answer,
                            //   "${widget.assignment.questions.length} questions",
                            //   TColor.secondary,
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Assignment Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: _buildDescriptionSection(),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: _buildQuestionsSection(),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: _buildSubmitSection(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.assignment.description,
            style: TextStyle(
              color: TColor.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Questions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: TColor.black,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.assignment.questions.length,
          itemBuilder: (context, index) {
            final question = widget.assignment.questions[index];
            return FadeInUp(
              delay: Duration(milliseconds: 800 + (index * 100)),
              child: _buildQuestionCard(question, index),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: TColor.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: TColor.black,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        _getQuestionTypeColor(question.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${question.maxPoints} pts",
                    style: TextStyle(
                      color: _getQuestionTypeColor(question.type),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColor.navBarBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getQuestionTypeText(question.type),
                style: TextStyle(
                  color: _getQuestionTypeColor(question.type),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (question.type == AssignmentType.multipleChoice)
              _buildMultipleChoiceQuestion(question, index)
            else
              _buildTextQuestion(question, index),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceQuestion(Question question, int index) {
    return Column(
      children: question.options!.map((option) {
        final isSelected = _selectedOptions[index] == option;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedOptions[index] = option;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isSelected ? TColor.primary.withOpacity(0.1) : TColor.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? TColor.primary : TColor.navBarBackground,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? TColor.primary : TColor.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? TColor.primary : TColor.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextQuestion(Question question, int index) {
    if (question.type == AssignmentType.shortAnswer) {
      return CustomTextForm(
        mycontroller: _answerControllers[index],
        hinttext: "Enter your answer...",
        secure: false,
        maxLines: 3,
      );
    } else {
      return CustomTextForm(
        mycontroller: _answerControllers[index],
        hinttext: "Enter your detailed response...",
        secure: false,
        maxLines: 6,
      );
    }
  }

  Widget _buildSubmitSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomButton(
            title: _existingSubmission != null
                ? "Update Submission"
                : "Submit Assignment",
            onTap: _submitAssignment,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: BorderSide(color: TColor.onSurfaceVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: TColor.onSurface,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getQuestionTypeColor(AssignmentType type) {
    switch (type) {
      case AssignmentType.multipleChoice:
        return TColor.primary;
      case AssignmentType.shortAnswer:
        return TColor.success;
      case AssignmentType.essay:
        return TColor.secondary;
      case AssignmentType.survey:
        return TColor.warning;
      case AssignmentType.quiz:
        return TColor.error;
    }
  }

  String _getQuestionTypeText(AssignmentType type) {
    switch (type) {
      case AssignmentType.multipleChoice:
        return "Multiple Choice";
      case AssignmentType.shortAnswer:
        return "Short Answer";
      case AssignmentType.essay:
        return "Essay";
      case AssignmentType.survey:
        return "Survey";
      case AssignmentType.quiz:
        return "Quiz";
    }
  }

  Future<void> _submitAssignment() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create answers from user input
      final answers = <Answer>[];
      for (int i = 0; i < widget.assignment.questions.length; i++) {
        final question = widget.assignment.questions[i];

        if (question.type == AssignmentType.multipleChoice) {
          if (_selectedOptions[i].isNotEmpty) {
            answers.add(
              Answer(
                questionId: question.id,
                selectedOption: _selectedOptions[i],
                answeredAt: DateTime.now(),
              ),
            );
          }
        } else {
          if (_answerControllers[i].text.trim().isNotEmpty) {
            answers.add(
              Answer(
                questionId: question.id,
                textAnswer: _answerControllers[i].text.trim(),
                answeredAt: DateTime.now(),
              ),
            );
          }
        }
      }

      // Get student name from Firebase
      final studentName = await _getStudentName(userId);

      // Create submission
      final submission = Submission(
        id: const Uuid().v4(),
        assignmentId: widget.assignment.id,
        assignmentTitle: widget.assignment.title,
        studentId: userId,
        studentName: studentName,
        studentEmail: FirebaseAuth.instance.currentUser?.email ?? "",
        answers: answers,
        createdAt: DateTime.now(),
        submittedAt: DateTime.now(),
        status: SubmissionStatus.submitted,
        maxScore: widget.assignment.totalPoints.toDouble(),
        isLateSubmission: DateTime.now().isAfter(widget.assignment.dueDate),
        timeSpentMinutes: 0, // Would track actual time in a real app
      );

      // Save submission to Firestore
      await _assignmentService.createSubmission(submission);

      Get.snackbar(
        "Success",
        "Assignment submitted successfully!",
        backgroundColor: TColor.success,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit assignment: $e",
        backgroundColor: TColor.error,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
