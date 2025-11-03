import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme.dart';

class StudySessionCard extends StatelessWidget {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final int participantCount;
  final VoidCallback onTap;
  final bool isUpcoming;

  const StudySessionCard({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.participantCount,
    required this.onTap,
    this.isUpcoming = true,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.j(); // Format like '9:30 AM'
    final dateFormat = DateFormat.MMMd(); // Format like 'Jan 15'

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: TColor.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isUpcoming
                  ? TColor.success.withOpacity(0.2)
                  : TColor.warning.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: isUpcoming
                  ? TColor.success.withOpacity(0.1)
                  : TColor.warning.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Time Circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isUpcoming ? TColor.success : TColor.warning,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.Hm().format(startTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '-${DateFormat.Hm().format(endTime)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Session Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: TColor.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dateFormat.format(startTime)} • ${startTime.day == endTime.day ? '' : '${dateFormat.format(endTime)} • '}${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}',
                      style: TextStyle(
                        color: TColor.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color: TColor.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$participantCount participants',
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

              // Status Indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? TColor.success.withOpacity(0.1)
                      : TColor.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isUpcoming ? 'Upcoming' : 'Completed',
                  style: TextStyle(
                    color: isUpcoming ? TColor.success : TColor.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
