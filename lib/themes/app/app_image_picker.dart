import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wheelbase/themes/appcolors.dart';
// import 'package:wheelbase/themes/appfonts.dart';

class AppImagePicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPick;
  final double height;

  const AppImagePicker({
    Key? key,
    required this.imageFile,
    required this.onPick,
    this.height = 160,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.backgroundLight,
            border: Border.all(color: AppColors.border),
          ),
          child: imageFile == null
              ? Center(
                  child: Icon(Icons.image_outlined,
                      size: 48, color: AppColors.secondary),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(imageFile!, fit: BoxFit.cover),
                ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: AppColors.primary,
            onPressed: onPick,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
