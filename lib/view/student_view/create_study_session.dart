// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custome_text_field.dart';
import '../../services/study_group_service.dart';
import '../../theme.dart';
import '../../model/study_session.dart';

class CreateStudySession extends StatefulWidget {
  final String groupId;

  const CreateStudySession({
    super.key,
    required this.groupId,
  });

  @override
  State<CreateStudySession> createState() => _CreateStudySessionState();
}

class _CreateStudySessionState extends State<CreateStudySession> {
  final studyGroupService = StudyGroupService();
  final titleController = TextEditingController();
  final notesController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isRecurring = false;
  String? recurrenceRule;
  bool isCreating = false;

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primary,
              onPrimary: Colors.white,
              onSurface: TColor.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primary,
              onPrimary: Colors.white,
              onSurface: TColor.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primary,
              onPrimary: Colors.white,
              onSurface: TColor.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  Future<void> createSession() async {
    if (titleController.text.isEmpty ||
        selectedDate == null ||
        startTime == null ||
        endTime == null) {
      Get.snackbar(
        "Error",
        "Please fill in all required fields",
        backgroundColor: TColor.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Convert to DateTime objects
    final startDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final endDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    // Validate end time is after start time
    if (endDateTime.isBefore(startDateTime)) {
      Get.snackbar(
        "Error",
        "End time must be after start time",
        backgroundColor: TColor.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      await studyGroupService.createStudySession(
        widget.groupId,
        titleController.text,
        startDateTime,
        endDateTime,
        notesController.text.isNotEmpty ? notesController.text : null,
        isRecurring: isRecurring,
        recurrenceRule: recurrenceRule,
      );
      Get.snackbar(
        "Success",
        "The ${titleController.text} sessions has been created.",
        backgroundColor: TColor.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Send notification to group members
      await studyGroupService.sendGroupNotification(
        widget.groupId,
        "New Study Session Scheduled",
        "${titleController.text} has been scheduled for ${DateFormat.yMMMd().format(selectedDate!)} at ${startTime!.format(context)}",
      );

      // Show success message
      // Get.snackbar(
      //   "Success",
      //   "Study session created successfully!",
      //   backgroundColor: TColor.success,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 3),
      //   snackPosition: SnackPosition.BOTTOM,
      // );

      // Navigate back
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create study session: ${e.toString()}",
        backgroundColor: TColor.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        title: const Text("Create Study Session"),
        backgroundColor: TColor.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Session Title
            CustomTextForm(
              hinttext: "Enter session title",
              mycontroller: titleController,
              secure: false,
              color: TColor.primary,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),

            // Date Selection
            _buildSelectionCard(
              icon: Icons.calendar_today,
              title: "Date",
              value: selectedDate != null
                  ? DateFormat.yMMMd().format(selectedDate!)
                  : "Select date",
              onTap: _selectDate,
            ),
            const SizedBox(height: 20),

            // Start Time
            _buildSelectionCard(
              icon: Icons.access_time,
              title: "Start Time",
              value: startTime?.format(context) ?? "Select start time",
              onTap: _selectStartTime,
            ),
            const SizedBox(height: 20),

            // End Time
            _buildSelectionCard(
              icon: Icons.access_time,
              title: "End Time",
              value: endTime?.format(context) ?? "Select end time",
              onTap: _selectEndTime,
            ),
            const SizedBox(height: 20),

            // Notes
            CustomTextForm(
              hinttext: "Add notes (optional)",
              mycontroller: notesController,
              secure: false,
              color: TColor.primary,
              maxLines: 3,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),

            // Recurring Session
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: TColor.primary.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Switch(
                      value: isRecurring,
                      onChanged: (value) {
                        setState(() {
                          isRecurring = value;
                          if (!value) {
                            recurrenceRule = null;
                          }
                        });
                      },
                      activeColor: TColor.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Recurring session",
                      style: TextStyle(
                        fontSize: 16,
                        color: TColor.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isRecurring) _buildRecurrenceOptions(),

            const SizedBox(height: 40),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCreating ? null : createSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isCreating
                    ? const CircularProgressIndicator.adaptive()
                    : const Text(
                        "Create Session",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: TColor.primary.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: TColor.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: TColor.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: TColor.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: TColor.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecurrenceOptions() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: TColor.primary.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recurrence",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TColor.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("Daily"),
                  selected: recurrenceRule == "daily",
                  selectedColor: TColor.primary,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        recurrenceRule = "daily";
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text("Weekly"),
                  selected: recurrenceRule == "weekly",
                  selectedColor: TColor.primary,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        recurrenceRule = "weekly";
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text("Monthly"),
                  selected: recurrenceRule == "monthly",
                  selectedColor: TColor.primary,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        recurrenceRule = "monthly";
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
