import 'package:flutter/material.dart';

/// Centralized color palette for Wheel Base
/// Access like: AppColors.primary, AppColors.background, etc.
class AppColors {
  // 🔴 Brand / Primary Colors
  static const Color primary = Color(0xFFAB0000); // Crimson Red
  static const Color secondary = Color(0xFF2E2E2E); // Slate Gray

  // 🎨 Backgrounds
  static const Color backgroundDark = Color(0xFF121212); 
  static const Color backgroundLight = Color(0xFFF5F5F5);

  // ✨ Accents
  static const Color accentBlue = Color(0xFF2D9CDB);
  static const Color accentGreen = Color(0xFF27AE60);
  static const Color accentOrange = Color(0xFFE67E22);

  // 📝 Text
  static const Color textPrimary = Color(0xFFF5F5F5); // For dark bg
  static const Color textSecondary = Color(0xFFB0B0B0); 
  static const Color textDark = Color(0xFF1C1C1C); // For light bg

  // ⚠️ Alerts
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);

  // 🛠️ Utility
  static const Color border = Color(0xFF3A3A3A);
  static const Color shadow = Color(0x33000000); // 20% opacity black
}
