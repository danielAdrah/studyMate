// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../theme.dart';

class StudyGroupCard extends StatelessWidget {
  final String groupName;
  final String courseName;
  final int memberCount;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool joinButtonVisible;
  final VoidCallback onJoinPressed;

  const StudyGroupCard({
    super.key,
    required this.groupName,
    required this.courseName,
    required this.memberCount,
    required this.onTap,
    this.isFavorite = false,
    required this.onFavoriteToggle,
    this.joinButtonVisible = false,
    required this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: TColor.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TColor.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Group Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.groups,
                    color: TColor.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Group Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: TextStyle(
                          color: TColor.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        courseName,
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                            '$memberCount members',
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

                // Favorite Button
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? TColor.error : TColor.onSurfaceVariant,
                    size: 20,
                  ),
                ),

                // Join Button (only show when joinButtonVisible is true)
                if (joinButtonVisible)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: onJoinPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        foregroundColor: TColor.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Join',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Chevron (only show when join button is not visible)
                if (!joinButtonVisible)
                  Icon(
                    Icons.chevron_right,
                    color: TColor.onSurfaceVariant,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
