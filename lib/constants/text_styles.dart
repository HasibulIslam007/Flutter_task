import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.lightText,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );
}
