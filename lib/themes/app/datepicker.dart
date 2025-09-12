// Add this helper widget in add_vehicle.dart or a shared widgets file

import 'package:flutter/material.dart';

class AppDatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onPick;

  const AppDatePicker({
    super.key,
    required this.label,
    required this.date,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onPick,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              date != null
                  ? "${date!.toLocal().toString().split(' ')[0]}"
                  : "Pick date",
              style: TextStyle(
                color: date != null ? Colors.black : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (date != null)
          TextButton(
            onPressed: onPick,
            child: const Text("Change date"),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}