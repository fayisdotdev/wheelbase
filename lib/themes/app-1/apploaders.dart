import 'package:flutter/material.dart';
import 'package:wheelbase/themes/appcolors.dart';

class AppLoader extends StatelessWidget {
  final double size;
  const AppLoader({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
