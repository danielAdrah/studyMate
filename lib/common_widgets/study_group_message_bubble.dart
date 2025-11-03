import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme.dart';

class StudyGroupMessageBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final DateTime timestamp;
  final bool isCurrentUser;

  const StudyGroupMessageBubble({
    super.key,
    required this.message,
    required this.senderName,
    required this.timestamp,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.jm(); // Format like '9:30 AM'

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isCurrentUser
                ? LinearGradient(
                    colors: [TColor.primary, TColor.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isCurrentUser ? null : TColor.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isCurrentUser
                  ? const Radius.circular(20)
                  : const Radius.circular(5),
              bottomRight: isCurrentUser
                  ? const Radius.circular(5)
                  : const Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: (isCurrentUser ? TColor.primary : TColor.black)
                    .withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: isCurrentUser
                ? null
                : Border.all(
                    color: TColor.primary.withOpacity(0.2),
                    width: 1,
                  ),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isCurrentUser ? TColor.white : TColor.onSurface,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: isCurrentUser ? 0 : 12,
            end: isCurrentUser ? 12 : 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCurrentUser)
                Text(
                  senderName,
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (!isCurrentUser) const SizedBox(width: 8),
              Text(
                timeFormat.format(timestamp),
                style: TextStyle(
                  color: TColor.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
