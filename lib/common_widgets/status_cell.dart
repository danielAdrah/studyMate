import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class StatusCell extends StatelessWidget {
  final VoidCallback? onTap;

  const StatusCell({
    super.key,
    required this.height,
    required this.width,
    required this.child,
    required this.title,
    required this.value,
    this.onTap,
  });

  final double height;
  final double width;
  final Widget child;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        width: double.infinity,
        height: height / 2.4,
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Stack(
          children: [
            // Main Card Container
            Container(
              width: double.infinity,
              height: height / 2.4,
              decoration: BoxDecoration(
                color: TColor.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: TColor.primary.withOpacity(0.1),
                    offset: Offset(0, 8),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),

            // Gradient Top Section
            Positioned(
              top: 8,
              right: 8,
              left: 8,
              height: height / 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColor.primary,
                      TColor.primary.withOpacity(0.8),
                      TColor.secondary.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: TColor.primary.withOpacity(0.3),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: child,
                ),
              ),
            ),

            // Bottom Information Section
            Positioned(
              top: height / 3.2,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        color: TColor.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),

                    // Value with enhanced styling
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: TColor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TColor.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            value,
                            style: TextStyle(
                              color: TColor.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Spacer(),

                        // Trending indicator
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: TColor.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: TColor.success,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Subtle accent line
            Positioned(
              top: height / 4 + 4,
              left: 20,
              right: 20,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColor.primary.withOpacity(0.3),
                      TColor.secondary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
