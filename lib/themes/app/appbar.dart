import 'package:flutter/material.dart';
import 'package:wheelbase/themes/appcolors.dart';
import 'package:wheelbase/themes/appfonts.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;

  const AppAppBar({
    super.key,
    required this.titleText,
    this.actions,
    this.centerTitle = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text(titleText, style: AppFonts.heading2.copyWith(color: Colors.white)),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
