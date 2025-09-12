// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart'; // For date formatting

class VehicleDetailPagerScreen extends StatefulWidget {
  final List<VehicleModel> vehicles;
  final int initialIndex;

  const VehicleDetailPagerScreen({
    super.key,
    required this.vehicles,
    required this.initialIndex,
  });

  @override
  State<VehicleDetailPagerScreen> createState() =>
      _VehicleDetailPagerScreenState();
}

class _VehicleDetailPagerScreenState extends State<VehicleDetailPagerScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.vehicles.length,
        itemBuilder: (context, index) {
          return VehicleDetailPage(vehicle: widget.vehicles[index]);
        },
      ),
    );
  }
}

class VehicleDetailPage extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailPage({super.key, required this.vehicle});

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  late TextEditingController _ownerController;
  late TextEditingController _vehicleNameController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _vehicleYearController;
  late TextEditingController _serviceKmController;
  late TextEditingController _batteryController;
  late TextEditingController _alignmentController;
  late TextEditingController _notesController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _refreshVehicle(); // Auto-refresh when page opens
  }

  void _initControllers() {
    _ownerController = TextEditingController(text: widget.vehicle.ownerName);
    _vehicleNameController = TextEditingController(
      text: widget.vehicle.vehicleName,
    );
    _vehicleNumberController = TextEditingController(
      text: widget.vehicle.vehicleNumber,
    );
    _vehicleYearController = TextEditingController(
      text: widget.vehicle.vehicleYear,
    );
    _serviceKmController = TextEditingController(
      text: widget.vehicle.serviceKm,
    );
    _batteryController = TextEditingController(
      text: widget.vehicle.battery ?? '',
    );
    _alignmentController = TextEditingController(
      text: widget.vehicle.alignment ?? '',
    );
    _notesController = TextEditingController(text: widget.vehicle.notes ?? '');
  }

  String formatDate(DateTime? dt) =>
      dt != null ? DateFormat('yyyy-MM-dd').format(dt) : "N/A";

  Future<void> _refreshVehicle() async {
    try {
      final vehicleId = widget.vehicle.vehicleId;

      // Fetch the vehicle from Supabase
      final data = await Supabase.instance.client
          .from('vehicles')
          .select()
          .eq('vehicle_id', vehicleId)
          .single(); // data is returned directly

      // Convert response data to VehicleModel
      final updatedVehicle = VehicleModel.fromJson(data);

      // Update the current vehicle in state
      setState(() {
        widget.vehicle.ownerName = updatedVehicle.ownerName;
        widget.vehicle.vehicleName = updatedVehicle.vehicleName;
        widget.vehicle.vehicleNumber = updatedVehicle.vehicleNumber;
        widget.vehicle.vehicleYear = updatedVehicle.vehicleYear;
        widget.vehicle.serviceKm = updatedVehicle.serviceKm;
        widget.vehicle.battery = updatedVehicle.battery;
        widget.vehicle.alignment = updatedVehicle.alignment;
        widget.vehicle.notes = updatedVehicle.notes;
        widget.vehicle.insuranceStarts = updatedVehicle.insuranceStarts;
        widget.vehicle.insuranceEnds = updatedVehicle.insuranceEnds;
        widget.vehicle.pollutionStarts = updatedVehicle.pollutionStarts;
        widget.vehicle.pollutionEnds = updatedVehicle.pollutionEnds;
        widget.vehicle.imageUrl = updatedVehicle.imageUrl;
        widget.vehicle.needNotification = updatedVehicle.needNotification;
        widget.vehicle.sharedWith = updatedVehicle.sharedWith;

        _initControllers();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('🔄 Vehicle refreshed')));
    } catch (e) {
      // Supabase throws if .single() fails, so no separate 'error' field needed
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error refreshing vehicle: $e')));
    }
  }

  Future<void> _saveChanges() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final updatedVehicle = VehicleModel(
      vehicleId: widget.vehicle.vehicleId,
      ownerName: _ownerController.text.trim(),
      vehicleName: _vehicleNameController.text.trim(),
      vehicleNumber: _vehicleNumberController.text.trim(),
      vehicleYear: _vehicleYearController.text.trim(),
      userAuthUuid: widget.vehicle.userAuthUuid,
      vehicleAddedBy: widget.vehicle.vehicleAddedBy,
      serviceKm: _serviceKmController.text.trim().isEmpty
          ? "0"
          : _serviceKmController.text.trim(),
      createdAt: widget.vehicle.createdAt,
      uploadedAt: widget.vehicle.uploadedAt,
      insuranceStarts: widget.vehicle.insuranceStarts,
      insuranceEnds: widget.vehicle.insuranceEnds,
      pollutionStarts: widget.vehicle.pollutionStarts,
      pollutionEnds: widget.vehicle.pollutionEnds,
      battery: _batteryController.text.trim().isEmpty
          ? null
          : _batteryController.text.trim(),
      alignment: _alignmentController.text.trim().isEmpty
          ? null
          : _alignmentController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      needNotification: widget.vehicle.needNotification,
      sharedWith: widget.vehicle.sharedWith,
      imageUrl: widget.vehicle.imageUrl,
    );

    try {
      await Supabase.instance.client
          .from('vehicles')
          .update(updatedVehicle.toJson())
          .eq('vehicle_id', updatedVehicle.vehicleId);

      setState(() => _isEditing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Vehicle updated')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating vehicle: $e')));
    }
  }

  Future<void> _deleteVehicle() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      await Supabase.instance.client
          .from('vehicles')
          .delete()
          .eq('vehicle_id', widget.vehicle.vehicleId);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('🗑 Vehicle deleted')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting vehicle: $e')));
    }
  }

  Future<void> _shareVehicleDetails() async {
    final vehicle = widget.vehicle;
    final details =
        '''
Vehicle: ${vehicle.vehicleName} (${vehicle.vehicleYear})
Owner: ${vehicle.ownerName}
Number: ${vehicle.vehicleNumber}
Service KM: ${vehicle.serviceKm}
Battery: ${vehicle.battery ?? 'N/A'}
Alignment: ${vehicle.alignment ?? 'N/A'}
Insurance: ${formatDate(vehicle.insuranceStarts)} → ${formatDate(vehicle.insuranceEnds)}
Pollution: ${formatDate(vehicle.pollutionStarts)} → ${formatDate(vehicle.pollutionEnds)}
Notes: ${vehicle.notes ?? 'N/A'}
Shared: ${vehicle.sharedWith ? "Yes" : "No"}
Notification: ${vehicle.needNotification ? "On" : "Off"}
''';
    await Share.share(details, subject: 'Vehicle Details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.vehicle.vehicleName),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: _buildFABs(),
      body: RefreshIndicator(
        onRefresh: _refreshVehicle,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildImage(),
            const SizedBox(height: 20),
            _buildDetailCard('Owner Name', _ownerController),
            _buildDetailCard('Vehicle Name', _vehicleNameController),
            _buildDetailCard('Vehicle Number', _vehicleNumberController),
            _buildDetailCard('Vehicle Year', _vehicleYearController),
            _buildDetailCard('Service KM', _serviceKmController),
            _buildDetailCard('Battery (Optional)', _batteryController),
            _buildDetailCard('Alignment (Optional)', _alignmentController),
            _buildDetailCard('Notes (Optional)', _notesController),
            const SizedBox(height: 12),
            // Add insurance & pollution dates here as read-only cards
            _buildReadOnlyCard(
              'Insurance',
              '${formatDate(widget.vehicle.insuranceStarts)} → ${formatDate(widget.vehicle.insuranceEnds)}',
            ),
            _buildReadOnlyCard(
              'Pollution',
              '${formatDate(widget.vehicle.pollutionStarts)} → ${formatDate(widget.vehicle.pollutionEnds)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFABs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: "editSave",
          backgroundColor: _isEditing ? Colors.green : Colors.blue,
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          label: Text(_isEditing ? 'Save' : 'Edit'),
          onPressed: () {
            if (_isEditing) {
              _saveChanges();
            } else {
              setState(() => _isEditing = true);
            }
          },
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "delete",
          backgroundColor: Colors.red.shade600,
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
          onPressed: _deleteVehicle,
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "share",
          backgroundColor: Colors.orange.shade700,
          icon: const Icon(Icons.share),
          label: const Text('Share'),
          onPressed: _shareVehicleDetails,
        ),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child:
          (widget.vehicle.imageUrl != null &&
              widget.vehicle.imageUrl!.isNotEmpty)
          ? FutureBuilder<String?>(
              future: context.read<VehicleProvider>().getSignedImageUrl(
                widget.vehicle.imageUrl!.replaceFirst(
                  RegExp(r'^.*vehicle-images2/'),
                  '',
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.directions_car,
                      size: 100,
                      color: Colors.black45,
                    ),
                  );
                }
                return Image.network(
                  snapshot.data!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            )
          : Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(
                Icons.directions_car,
                size: 100,
                color: Colors.black45,
              ),
            ),
    );
  }

  Widget _buildDetailCard(String label, TextEditingController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: controller,
          enabled: _isEditing,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text('$label: $value', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
