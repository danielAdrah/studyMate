import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/assignment.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback? onTap;
  final bool showProgress;
  final Widget? trailing;

  const AssignmentCard({
    super.key,
    required this.assignment,
    this.onTap,
    this.showProgress = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                  _buildStatusChip(assignment.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                assignment.courseName,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                assignment.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    "Due: ${DateFormat('MMM dd, yyyy HH:mm').format(assignment.dueDate)}",
                    style: TextStyle(
                      color:
                          assignment.isOverdue ? Colors.red : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  if (assignment.isPublished) ...[
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "${assignment.submissionCount} submissions",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ],
              ),
              if (showProgress && assignment.submissionCount > 0) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: assignment.gradingProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    assignment.gradingProgress == 1.0
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Graded: ${assignment.gradedCount}/${assignment.submissionCount}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(AssignmentStatus status) {
    Color color;
    switch (status) {
      case AssignmentStatus.draft:
        color = Colors.grey;
        break;
      case AssignmentStatus.published:
        color = Colors.green;
        break;
      case AssignmentStatus.closed:
        color = Colors.blue;
        break;
      case AssignmentStatus.graded:
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
