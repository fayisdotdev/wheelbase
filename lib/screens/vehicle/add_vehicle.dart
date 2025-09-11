// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';

class AddVehiclePage extends StatefulWidget {
  final VehicleModel? vehicle; // optional vehicle for editing

  const AddVehiclePage({super.key, this.vehicle});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  final _ownerController = TextEditingController();
  final _vehicleNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _serviceKmController = TextEditingController();
  final _batteryController = TextEditingController();
  final _alignmentController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _insuranceStarts;
  DateTime? _insuranceEnds;
  DateTime? _pollutionStarts;
  DateTime? _pollutionEnds;

  bool _needNotification = false;
  bool _sharedWith = false;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _existingImageUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _loadVehicleData(widget.vehicle!);
    }
  }

  void _loadVehicleData(VehicleModel vehicle) {
    _ownerController.text = vehicle.ownerName;
    _vehicleNameController.text = vehicle.vehicleName;
    _vehicleNumberController.text = vehicle.vehicleNumber;
    _vehicleYearController.text = vehicle.vehicleYear;
    _serviceKmController.text = vehicle.serviceKm;
    _batteryController.text = vehicle.battery ?? '';
    _alignmentController.text = vehicle.alignment ?? '';
    _notesController.text = vehicle.notes ?? '';
    _insuranceStarts = vehicle.insuranceStarts;
    _insuranceEnds = vehicle.insuranceEnds;
    _pollutionStarts = vehicle.pollutionStarts;
    _pollutionEnds = vehicle.pollutionEnds;
    _needNotification = vehicle.needNotification;
    _sharedWith = vehicle.sharedWith;
    _existingImageUrl = vehicle.imageUrl;
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _existingImageUrl = null; // clear existing image if new one picked
      });
    }
  }

  Future<void> _pickDate(Function(DateTime) onPicked) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      initialDate: now,
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    if (_insuranceStarts == null ||
        _insuranceEnds == null ||
        _pollutionStarts == null ||
        _pollutionEnds == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all date fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in")));
        setState(() => _isLoading = false);
        return;
      }

      final vehicleProvider = context.read<VehicleProvider>();
      String? imageUrl = _existingImageUrl;

      // ...existing code...
      if (_imageFile != null) {
        imageUrl = await vehicleProvider.uploadImage(_imageFile!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Image upload failed!")));
        }
      }
      // ...existing code...

      final vehicle = VehicleModel(
        vehicleId: widget.vehicle?.vehicleId ?? const Uuid().v4(),
        ownerName: _ownerController.text.trim(),
        vehicleName: _vehicleNameController.text.trim(),
        vehicleNumber: _vehicleNumberController.text.trim(),
        vehicleYear: _vehicleYearController.text.trim(),
        userAuthUuid: user.id,
        vehicleAddedBy: widget.vehicle?.vehicleAddedBy ?? user.id,
        serviceKm: _serviceKmController.text.trim().isEmpty
            ? "0"
            : _serviceKmController.text.trim(),
        createdAt: widget.vehicle?.createdAt ?? DateTime.now(),
        insuranceStarts: _insuranceStarts,
        insuranceEnds: _insuranceEnds,
        pollutionStarts: _pollutionStarts,
        pollutionEnds: _pollutionEnds,
        battery: _batteryController.text.trim().isEmpty
            ? null
            : _batteryController.text.trim(),
        alignment: _alignmentController.text.trim().isEmpty
            ? null
            : _alignmentController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        needNotification: _needNotification,
        sharedWith: _sharedWith,
        imageUrl: imageUrl,
      );

      bool success;
      if (widget.vehicle != null) {
        success = await vehicleProvider.updateVehicle(vehicle);
      } else {
        success = await vehicleProvider.addVehicle(vehicle);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.vehicle != null
                  ? "Vehicle updated successfully!"
                  : "Vehicle added successfully!",
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.vehicle != null
                  ? "Failed to update vehicle."
                  : "Failed to add vehicle.",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildDateField(
    String label,
    DateTime? value,
    Function(DateTime) onPicked,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value != null
                ? "$label: ${value.toLocal().toString().split(' ')[0]}"
                : "$label: Not selected",
          ),
        ),
        TextButton(
          onPressed: () => _pickDate(onPicked),
          child: const Text("Pick Date"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _vehicleNameController.dispose();
    _vehicleNumberController.dispose();
    _vehicleYearController.dispose();
    _serviceKmController.dispose();
    _batteryController.dispose();
    _alignmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle != null ? "Edit Vehicle" : "Add Vehicle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _ownerController,
                  decoration: const InputDecoration(labelText: "Owner Name"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _vehicleNameController,
                  decoration: const InputDecoration(labelText: "Vehicle Name"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _vehicleNumberController,
                  decoration: const InputDecoration(
                    labelText: "Vehicle Number",
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _vehicleYearController,
                  decoration: const InputDecoration(labelText: "Vehicle Year"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                _buildDateField(
                  "Insurance Start",
                  _insuranceStarts,
                  (date) => setState(() => _insuranceStarts = date),
                ),
                _buildDateField(
                  "Insurance End",
                  _insuranceEnds,
                  (date) => setState(() => _insuranceEnds = date),
                ),
                _buildDateField(
                  "Pollution Start",
                  _pollutionStarts,
                  (date) => setState(() => _pollutionStarts = date),
                ),
                _buildDateField(
                  "Pollution End",
                  _pollutionEnds,
                  (date) => setState(() => _pollutionEnds = date),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _serviceKmController,
                  decoration: const InputDecoration(labelText: "Service KM"),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _batteryController,
                  decoration: const InputDecoration(
                    labelText: "Battery (Optional)",
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _alignmentController,
                  decoration: const InputDecoration(
                    labelText: "Alignment (Optional)",
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: "Notes (Optional)",
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text("Need Notifications"),
                  value: _needNotification,
                  onChanged: (val) => setState(() => _needNotification = val),
                ),
                SwitchListTile(
                  title: const Text("Shared With Others"),
                  value: _sharedWith,
                  onChanged: (val) => setState(() => _sharedWith = val),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )
                        : _existingImageUrl != null
                        ? Image.network(
                            _existingImageUrl!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 80,
                            width: 80,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.directions_car),
                          ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload),
                      label: const Text("Pick Image (Optional)"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveVehicle,
                        child: Text(
                          widget.vehicle != null
                              ? "Update Vehicle"
                              : "Save Vehicle",
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
