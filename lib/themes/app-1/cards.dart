import 'package:flutter/material.dart';
import 'package:wheelbase/themes/appcolors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundDark,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 4,
      child: Padding(padding: padding, child: child),
    );
  }
}
