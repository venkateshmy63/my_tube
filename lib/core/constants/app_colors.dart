// Import Flutter's Color class
import 'package:flutter/material.dart';

/// App color palette as defined in the PRD
class AppColors {
  // Primary colors
  static const primary = Color(0xFF1A1A2E); // Deep navy
  static const accent = Color(0xFF0F3460); // Electric indigo
  static const highlight = Color(0xFFE94560); // Vivid red-pink
  static const surface = Color(0xFF16213E); // Dark card surface
  static const background = Color(0xFF0A0A1A); // Near-black bg
  
  // On colors (text/icons on colored backgrounds)
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFFE0E0E0);
  static const subtle = Color(0xFF6C7A93); // Muted label text
  
  // Semantic colors
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);
  
  // Additional UI colors
  static const divider = Color(0x1FFFFFFF);
  static const overlay = Color(0x66000000);
  
  // Gradient colors
  static const gradientStart = Color(0xFF1A1A2E);
  static const gradientEnd = Color(0xFF16213E);
}