import 'package:flutter/material.dart';
import 'package:wheelbase/themes/appcolors.dart';
class AppFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const AppFab({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon, color: Colors.white),
    );
  }
}
