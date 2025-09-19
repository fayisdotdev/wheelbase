import 'package:flutter/material.dart';
import 'package:wheelbase/themes/appcolors.dart';
import 'package:wheelbase/themes/appfonts.dart';


class AppSectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const AppSectionTitle({
    Key? key,
    required this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: AppColors.primary, size: 20),
          if (icon != null) const SizedBox(width: 6),
          Text(
            title,
            style: AppFonts.caption.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
