import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/forms/vehicle_form.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';

class EditVehiclePage extends StatefulWidget {
  final VehicleModel vehicle;
  const EditVehiclePage({super.key, required this.vehicle});

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  late VehicleModel _editingVehicle;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _editingVehicle = widget.vehicle;
  }

  Future<void> _saveVehicle(VehicleModel updated) async {
    setState(() => _isSaving = true);
    final success =
        await context.read<VehicleProvider>().updateVehicle(updated);
    setState(() => _isSaving = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle updated successfully")),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update vehicle")),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _editingVehicle = widget.vehicle;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form reset to original data")),
    );
  }

  Future<void> _deleteVehicle() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Vehicle"),
        content: const Text(
          "This action cannot be undone. Are you sure you want to delete this vehicle?",
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await context
          .read<VehicleProvider>()
          .deleteVehicle(widget.vehicle.vehicleId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vehicle deleted successfully")),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete vehicle")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Edit Vehicle"),
        centerTitle: true,
        actions: [
          // ✅ Save button (top-right checkmark)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving
                ? null
                : () {
                    _saveVehicle(_editingVehicle);
                  },
          ),
          // ✅ 3-dot menu (reset / delete)
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case "reset":
                  _resetForm();
                  break;
                case "delete":
                  _deleteVehicle();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "reset",
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text("Reset Form"),
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text("Delete Vehicle"),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          VehicleForm(
            initialData: _editingVehicle,
            isEditing: true, // 🔑 makes every field editable
            onSave: (updatedVehicle) {
              setState(() => _editingVehicle = updatedVehicle);
            },
          ),
          if (_isSaving)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
