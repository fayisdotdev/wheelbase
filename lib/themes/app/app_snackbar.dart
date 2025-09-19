import 'package:flutter/material.dart';
import 'package:wheelbase/themes/appcolors.dart';
import 'package:wheelbase/themes/appfonts.dart';


class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final snackBar = SnackBar(
      backgroundColor: isError ? AppColors.error : AppColors.success,
      content: Text(
        message,
        style: AppFonts.body.copyWith(color: Colors.white),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
