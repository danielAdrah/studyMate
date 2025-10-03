// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TColor {
  // Modern Blue Academic Palette
  static Color get primary => const Color(0xFF3B82F6); // Vibrant blue
  static Color get secondary => const Color(0xFF8B5CF6); // Purple accent
  static Color get accent => const Color(0xFF06B6D4); // Cyan accent
  static Color get success => const Color(0xFF10B981); // Green for success
  static Color get warning => const Color(0xFFF59E0B); // Amber for warnings
  static Color get error => const Color(0xFFEF4444); // Red for errors

  static Color get background => const Color(0xFFF8FAFC); // Soft blue-gray
  static Color get navBarBackground =>
      const Color(0xFFE2E8F0); // Lighter blue-gray
  static Color get surface => const Color(0xFFFFFFFF); // Pure white for cards

  static Color get onPrimary => Colors.white;
  static Color get onSurface => const Color(0xFF1E293B); // Dark blue-gray
  static Color get onSurfaceVariant => const Color(0xFF64748B); // Medium gray

  static Color get white => Colors.white;
  static Color get black => Colors.black;
}
