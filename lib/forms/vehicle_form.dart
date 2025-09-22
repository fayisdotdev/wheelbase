import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheelbase/models/vehicles_model.dart';

class VehicleForm extends StatefulWidget {
  final VehicleModel? initialData;
  final bool isEditing;
  final Function(VehicleModel) onSave;

  const VehicleForm({
    super.key,
    this.initialData,
    required this.isEditing,
    required this.onSave,
  });

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _vehicleNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _serviceKmController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _insuranceStarts;
  DateTime? _insuranceEnds;
  DateTime? _pollutionStarts;
  DateTime? _pollutionEnds;
  bool _needNotification = false;
  bool _sharedWith = false;
  String? _imageUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final v = widget.initialData!;
      _vehicleNameController.text = v.vehicleName;
      _vehicleNumberController.text = v.vehicleNumber;
      _vehicleYearController.text = v.vehicleYear;
      _ownerNameController.text = v.ownerName;
      _serviceKmController.text = v.serviceKm;
      _notesController.text = v.notes ?? "";
      _insuranceStarts = v.insuranceStarts;
      _insuranceEnds = v.insuranceEnds;
      _pollutionStarts = v.pollutionStarts;
      _pollutionEnds = v.pollutionEnds;
      _needNotification = v.needNotification;
      _sharedWith = v.sharedWith;
      _imageUrl = v.imageUrl;
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStart, bool isInsurance) async {
    final current = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(current.year - 5),
      lastDate: DateTime(current.year + 10),
    );
    if (selected != null) {
      setState(() {
        if (isInsurance) {
          if (isStart) {
            _insuranceStarts = selected;
          } else {
            _insuranceEnds = selected;
          }
        } else {
          if (isStart) {
            _pollutionStarts = selected;
          } else {
            _pollutionEnds = selected;
          }
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Image Picker
            if (widget.isEditing)
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (_imageUrl != null
                          ? NetworkImage(_imageUrl!)
                          : null) as ImageProvider?,
                  child: _pickedImage == null && _imageUrl == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _vehicleNameController,
              enabled: widget.isEditing,
              decoration: const InputDecoration(labelText: "Vehicle Name"),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _vehicleNumberController,
              enabled: widget.isEditing,
              decoration: const InputDecoration(labelText: "Vehicle Number"),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _vehicleYearController,
              enabled: widget.isEditing,
              decoration: const InputDecoration(labelText: "Vehicle Year"),
            ),
            TextFormField(
              controller: _ownerNameController,
              enabled: widget.isEditing,
              decoration: const InputDecoration(labelText: "Owner Name"),
            ),
            TextFormField(
              controller: _serviceKmController,
              enabled: widget.isEditing,
              decoration: const InputDecoration(labelText: "Service KM"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _notesController,
              enabled: widget.isEditing,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Notes"),
            ),

            const SizedBox(height: 16),
            // Date pickers
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(_insuranceStarts != null
                        ? "Insurance Start: ${_insuranceStarts!.toLocal().toString().split(" ")[0]}"
                        : "Select Insurance Start"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: widget.isEditing
                        ? () => _pickDate(context, true, true)
                        : null,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(_insuranceEnds != null
                        ? "Insurance End: ${_insuranceEnds!.toLocal().toString().split(" ")[0]}"
                        : "Select Insurance End"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: widget.isEditing
                        ? () => _pickDate(context, false, true)
                        : null,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(_pollutionStarts != null
                        ? "Pollution Start: ${_pollutionStarts!.toLocal().toString().split(" ")[0]}"
                        : "Select Pollution Start"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: widget.isEditing
                        ? () => _pickDate(context, true, false)
                        : null,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(_pollutionEnds != null
                        ? "Pollution End: ${_pollutionEnds!.toLocal().toString().split(" ")[0]}"
                        : "Select Pollution End"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: widget.isEditing
                        ? () => _pickDate(context, false, false)
                        : null,
                  ),
                ),
              ],
            ),

            // Switches
            SwitchListTile(
              value: _needNotification,
              onChanged: widget.isEditing
                  ? (val) => setState(() => _needNotification = val)
                  : null,
              title: const Text("Need Notifications"),
            ),
            SwitchListTile(
              value: _sharedWith,
              onChanged: widget.isEditing
                  ? (val) => setState(() => _sharedWith = val)
                  : null,
              title: const Text("Shared With Others"),
            ),

            const SizedBox(height: 20),
            if (widget.isEditing)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final vehicle = VehicleModel(
                      vehicleId:
                          widget.initialData?.vehicleId ??
                              DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                      vehicleName: _vehicleNameController.text,
                      vehicleNumber: _vehicleNumberController.text,
                      vehicleYear: _vehicleYearController.text,
                      ownerName: _ownerNameController.text,
                      serviceKm: _serviceKmController.text,
                      notes: _notesController.text,
                      insuranceStarts: _insuranceStarts,
                      insuranceEnds: _insuranceEnds,
                      pollutionStarts: _pollutionStarts,
                      pollutionEnds: _pollutionEnds,
                      needNotification: _needNotification,
                      sharedWith: _sharedWith,
                      createdAt: widget.initialData?.createdAt ?? DateTime.now(),
                      uploadedAt: DateTime.now(),
                      userAuthUuid: widget.initialData?.userAuthUuid ?? "",
                      vehicleAddedBy: widget.initialData?.vehicleAddedBy ?? "",
                      imageUrl: _imageUrl,
                    );
                    widget.onSave(vehicle);
                  }
                },
                child: const Text("Save Vehicle"),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _vehicleNameController.dispose();
    _vehicleNumberController.dispose();
    _vehicleYearController.dispose();
    _ownerNameController.dispose();
    _serviceKmController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
