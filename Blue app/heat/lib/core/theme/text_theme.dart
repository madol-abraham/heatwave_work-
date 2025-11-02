import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return TextTheme(
      // H1 - Main titles, screen titles (32-36px)
      headlineLarge: GoogleFonts.roboto(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: AppColors.text,
      ),
      
      // H2 - Section headers, major UI elements (24-28px)
      headlineMedium: GoogleFonts.roboto(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.text,
      ),
      
      // H3 - Subheaders, card titles (20-22px)
      headlineSmall: GoogleFonts.roboto(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.text,
      ),
      
      // Body text (16px)
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.text,
      ),
      
      // Body medium (16px)
      bodyMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.text,
      ),
      
      // Body small - Descriptions, notes, meta information (14px)
      bodySmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      
      // Labels
      labelLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.text,
      ),
      
      labelMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.text,
      ),
      
      labelSmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
      ),
    );
  }
}