import 'dart:io';
import 'package:flutter/material.dart';
import '../../themes/app/app_image_picker.dart';

class VehicleImageUploader extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPick;

  const VehicleImageUploader({
    Key? key,
    required this.imageFile,
    required this.onPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppImagePicker(
      imageFile: imageFile,
      onPick: onPick,
      height: 200,
    );
  }
}
