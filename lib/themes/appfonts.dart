import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized font styles for Wheel Base
/// Uses Poppins everywhere
class AppFonts {
  // Base font family
  static TextTheme textTheme = GoogleFonts.poppinsTextTheme();

  // Optional reusable text styles
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
}
