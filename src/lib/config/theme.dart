import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Oficial Color Palette
  static const Color primaryColor = Color(0xFF3A5A40);
  static const Color accentColor = Color(0xFFA3B18A); // Or Secondary Color
  static const Color borderColor = Color(0xFFE7E0D6);
  static const Color mutedText = Color(0xFF4B5563);
  static const Color primaryText = Color(0xFF000000);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFFBF7EF);

  static const Color redAccent = Color(0xFFFF0000);
  static const Color greenAccent = Color(
    0xFF5FFF89,
  ); // For success messages or "Add to..." actions

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,

      scaffoldBackgroundColor: backgroundColor,

      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        outline: borderColor,
      ),

      // Oficial Typography (Poppins and Inter)
      textTheme: TextTheme(
        // H1
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700, // Bold
          height: 1.2, // 120%
          color: primaryText,
        ),
        // H2
        displayMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600, // SemiBold
          height: 1.2,
          color: primaryText,
        ),
        // H3
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500, // Medium
          height: 1.3,
          color: primaryText,
        ),
        // Body L
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400, // Regular
          height: 1.5,
          color: primaryText,
        ),
        // Body M
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400, // Regular
          height: 1.5,
          color: mutedText,
        ),
        // Caption
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500, // Medium
          height: 1.4,
          color: mutedText,
        ),
      ),
    );
  }
}
