// lib/pages/add_vehicle_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';

class AddVehiclePage extends StatefulWidget {
  final VehicleModel? vehicle;

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
        _existingImageUrl = null;
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

      if (_imageFile != null) {
        imageUrl = await vehicleProvider.uploadImage(_imageFile!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Image upload failed!")));
        }
      }

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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required Function(DateTime) onPicked,
    IconData icon = Icons.calendar_today,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(label),
        subtitle: Text(
          date != null
              ? "${date.toLocal().toString().split(' ')[0]}"
              : "Not selected",
          style: TextStyle(
            color: date != null ? Colors.black : Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.edit_calendar),
        onTap: () async {
          await _pickDate(onPicked);
        },
      ),
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.vehicle != null ? "Edit Vehicle" : "Add Vehicle"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle Image
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            )
                          : _existingImageUrl != null
                              ? FutureBuilder<String?>(
                                  future: context
                                      .read<VehicleProvider>()
                                      .getSignedImageUrl(
                                        _existingImageUrl!.replaceFirst(
                                          RegExp(r'^.*vehicle-images2/'),
                                          '',
                                        ),
                                      ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError ||
                                        snapshot.data == null) {
                                      return Container(
                                        height: 150,
                                        width: 150,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.broken_image,
                                            size: 40),
                                      );
                                    }
                                    return Image.network(
                                      snapshot.data!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.directions_car,
                                      size: 50),
                                ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: FloatingActionButton.small(
                        heroTag: "pickImage",
                        onPressed: _pickImage,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),

              _sectionTitle("Basic Information"),
              _inputField(
                controller: _ownerController,
                hint: "Owner Name",
                icon: Icons.person,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              _inputField(
                controller: _vehicleNameController,
                hint: "Vehicle Name",
                icon: Icons.directions_car,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              _inputField(
                controller: _vehicleNumberController,
                hint: "Vehicle Number",
                icon: Icons.confirmation_number,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              _inputField(
                controller: _vehicleYearController,
                hint: "Vehicle Year",
                icon: Icons.calendar_month,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),

              _sectionTitle("Insurance Details"),
              _dateField(
                label: "Insurance Start",
                date: _insuranceStarts,
                onPicked: (picked) => setState(() => _insuranceStarts = picked),
              ),
              _dateField(
                label: "Insurance End",
                date: _insuranceEnds,
                onPicked: (picked) => setState(() => _insuranceEnds = picked),
              ),

              _sectionTitle("Pollution Details"),
              _dateField(
                label: "Pollution Start",
                date: _pollutionStarts,
                onPicked: (picked) => setState(() => _pollutionStarts = picked),
              ),
              _dateField(
                label: "Pollution End",
                date: _pollutionEnds,
                onPicked: (picked) => setState(() => _pollutionEnds = picked),
              ),

              _sectionTitle("Other Info"),
              _inputField(
                controller: _serviceKmController,
                hint: "Service KM",
                icon: Icons.speed,
              ),
              _inputField(
                controller: _batteryController,
                hint: "Battery (Optional)",
                icon: Icons.battery_charging_full,
              ),
              _inputField(
                controller: _alignmentController,
                hint: "Alignment (Optional)",
                icon: Icons.tune,
              ),
              _inputField(
                controller: _notesController,
                hint: "Notes (Optional)",
                icon: Icons.note,
              ),

              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text("Need Notifications"),
                subtitle: const Text("Enable reminders for services & insurance"),
                value: _needNotification,
                onChanged: (val) => setState(() => _needNotification = val),
              ),
              SwitchListTile(
                title: const Text("Shared With Others"),
                subtitle: const Text("Allow other users to view this vehicle"),
                value: _sharedWith,
                onChanged: (val) => setState(() => _sharedWith = val),
              ),

              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: _saveVehicle,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        widget.vehicle != null
                            ? "Update Vehicle"
                            : "Save Vehicle",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
