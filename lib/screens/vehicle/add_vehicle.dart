import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';

// Reusable UI

import 'package:wheelbase/themes/app/app_fab.dart';
import 'package:wheelbase/themes/app/app_snackbar.dart';
import 'package:wheelbase/themes/vehicle/app_text_field.dart';
import 'package:wheelbase/themes/vehicle/vehicle_switches.dart';
import 'package:wheelbase/themes/vehicle/vehicles_form_section.dart';
import 'package:wheelbase/themes/vehicle/vehicles_image_uploader.dart';

// Vehicle Widgets

class AddVehiclePage extends StatefulWidget {
  final VehicleModel? vehicle;
  final bool isEditing;

  const AddVehiclePage({
    Key? key,
    this.vehicle, // optional
    this.isEditing = false, // defaults to false
  }) : super(key: key);

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  // Controllers
  final _ownerCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _serviceKmCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  File? _pickedImage;
  bool _needNotification = false;
  bool _sharedWith = false;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _ownerCtrl.text = widget.vehicle!.ownerName;
      _nameCtrl.text = widget.vehicle!.vehicleName;
      _numberCtrl.text = widget.vehicle!.vehicleNumber;
      _yearCtrl.text = widget.vehicle!.vehicleYear;
      _serviceKmCtrl.text = widget.vehicle!.serviceKm;
      _notesCtrl.text = widget.vehicle!.notes ?? '';
      _needNotification = widget.vehicle!.needNotification;
      _sharedWith = widget.vehicle!.sharedWith;
      // Image? -> you can fetch signed URL if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Vehicle")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Image Upload
            VehicleImageUploader(
              imageFile: _pickedImage,
              onPick: () async {
                // TODO: Move to provider or image util
              },
            ),

            /// Vehicle Info
            VehicleFormSection(
              title: "Vehicle Info",
              fields: [
                AppTextField(controller: _ownerCtrl, label: "Owner Name"),
                AppTextField(controller: _nameCtrl, label: "Vehicle Name"),
                AppTextField(controller: _numberCtrl, label: "Number Plate"),
                AppTextField(
                  controller: _yearCtrl,
                  label: "Year",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            /// Service Info
            VehicleFormSection(
              title: "Service Details",
              fields: [
                AppTextField(
                  controller: _serviceKmCtrl,
                  label: "Service KM",
                  keyboardType: TextInputType.number,
                ),
                AppTextField(
                  controller: _notesCtrl,
                  label: "Notes",
                  multiline: true,
                ),
              ],
            ),

            /// Switches
            VehicleSwitches(
              needNotification: _needNotification,
              sharedWith: _sharedWith,
              onNotificationChanged: (v) =>
                  setState(() => _needNotification = v),
              onSharedChanged: (v) => setState(() => _sharedWith = v),
            ),
          ],
        ),
      ),

      /// Save Button
      floatingActionButton: AppFab(
  icon: Icons.save,
  onPressed: () async {
    final vehicle = VehicleModel(
      vehicleId: widget.vehicle?.vehicleId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      ownerName: _ownerCtrl.text,
      vehicleName: _nameCtrl.text,
      vehicleNumber: _numberCtrl.text,
      vehicleYear: _yearCtrl.text,
      serviceKm: _serviceKmCtrl.text,
      notes: _notesCtrl.text,
      needNotification: _needNotification,
      sharedWith: _sharedWith,
      userAuthUuid: vehicleProvider.supabase.auth.currentUser?.id ?? "",
      vehicleAddedBy: vehicleProvider.supabase.auth.currentUser?.email ?? "",
    );

    bool success;
    if (widget.isEditing) {
      success = await vehicleProvider.updateVehicle(vehicle);
    } else {
      success = await vehicleProvider.addVehicle(vehicle);
    }

    if (success && mounted) {
      AppSnackbar.show(context, widget.isEditing ? "Vehicle updated!" : "Vehicle added!");
      Navigator.pop(context, true);
    } else {
      AppSnackbar.show(context, "Failed to save vehicle", isError: true);
    }
  },
),

    );
  }
}
