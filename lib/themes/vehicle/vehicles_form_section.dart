import 'package:flutter/material.dart';
import '../../themes/app/app_section_title.dart';

class VehicleFormSection extends StatelessWidget {
  final String title;
  final List<Widget> fields;

  const VehicleFormSection({
    Key? key,
    required this.title,
    required this.fields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(title: title, icon: Icons.directions_car),
        const SizedBox(height: 8),
        ...fields,
        const SizedBox(height: 16),
      ],
    );
  }
}
