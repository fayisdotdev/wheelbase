import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/forms/vehicle_form.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';

class AddVehiclePage extends StatelessWidget {
  const AddVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vehicle")),
      body: VehicleForm(
        isEditing: true,
        onSave: (vehicle) async {
          final success =
              await context.read<VehicleProvider>().addVehicle(vehicle);
          if (success && context.mounted) Navigator.pop(context, true);
        },
      ),
    );
  }
}
