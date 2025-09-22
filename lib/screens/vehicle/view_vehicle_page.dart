// view_vehicle_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';
import 'edit_vehicle_page.dart';

class ViewVehiclePage extends StatefulWidget {
  final VehicleModel vehicle;
  const ViewVehiclePage({super.key, required this.vehicle});

  @override
  State<ViewVehiclePage> createState() => _ViewVehiclePageState();
}

class _ViewVehiclePageState extends State<ViewVehiclePage> {
  bool _isLoading = false;

  String _formatDate(DateTime? dt) =>
      dt != null ? dt.toLocal().toString().split(' ')[0] : "Not Set";

  Future<void> _deleteVehicle() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Vehicle"),
        content: const Text(
          "Are you sure you want to delete this vehicle? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      final provider = Provider.of<VehicleProvider>(context, listen: false);
      final success = await provider.deleteVehicle(widget.vehicle.vehicleId);

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vehicle deleted successfully")),
          );
          Navigator.pop(context); // go back to list page
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete vehicle")),
        );
      }
    }
  }

  Future<void> _shareVehicle() async {
    final v = widget.vehicle;
    final details =
        '''
🚗 Vehicle Details
------------------------
Name: ${v.vehicleName} (${v.vehicleYear})
Owner: ${v.ownerName}
Number: ${v.vehicleNumber}
Service KM: ${v.serviceKm}
Battery: ${v.battery ?? 'N/A'}
Alignment: ${v.alignment ?? 'N/A'}

Insurance: ${_formatDate(v.insuranceStarts)} → ${_formatDate(v.insuranceEnds)}
Pollution: ${_formatDate(v.pollutionStarts)} → ${_formatDate(v.pollutionEnds)}

Notes: ${v.notes ?? 'No Notes'}
Shared: ${v.sharedWith ? "Yes" : "No"}
Notifications: ${v.needNotification ? "Enabled" : "Disabled"}
''';
    await Share.share(details, subject: 'Vehicle Info');
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _infoTile(String label, String value, {IconData? icon}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
        title: Text(label),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Vehicle Details"), centerTitle: true),
      floatingActionButton: SpeedDial(
        icon: Icons.more_vert,
        activeIcon: Icons.close,
        backgroundColor: Colors.blueAccent,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.edit, color: Colors.white),
            label: "Edit",
            backgroundColor: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditVehiclePage(vehicle: v)),
            ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete, color: Colors.white),
            label: "Delete",
            backgroundColor: Colors.red,
            onTap: _deleteVehicle,
          ),
          SpeedDialChild(
            child: const Icon(Icons.share, color: Colors.white),
            label: "Share",
            backgroundColor: Colors.green,
            onTap: _shareVehicle,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vehicle Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: v.imageUrl != null
                          ? FutureBuilder<String?>(
                              future: context
                                  .read<VehicleProvider>()
                                  .getSignedImageUrl(
                                    v.imageUrl!.replaceFirst(
                                      RegExp(r'^.*vehicle-images2/'),
                                      '',
                                    ),
                                  ),
                              builder: (ctx, snapshot) {
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
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
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
                              child: const Icon(Icons.directions_car, size: 50),
                            ),
                    ),
                  ),

                  _sectionTitle("Basic Information"),
                  _infoTile("Owner", v.ownerName, icon: Icons.person),
                  _infoTile(
                    "Vehicle Name",
                    v.vehicleName,
                    icon: Icons.directions_car,
                  ),
                  _infoTile(
                    "Vehicle Number",
                    v.vehicleNumber,
                    icon: Icons.confirmation_number,
                  ),
                  _infoTile(
                    "Vehicle Year",
                    v.vehicleYear,
                    icon: Icons.calendar_month,
                  ),

                  _sectionTitle("Insurance Details"),
                  _infoTile(
                    "Insurance Start",
                    _formatDate(v.insuranceStarts),
                    icon: Icons.calendar_today,
                  ),
                  _infoTile(
                    "Insurance End",
                    _formatDate(v.insuranceEnds),
                    icon: Icons.calendar_today,
                  ),

                  _sectionTitle("Pollution Details"),
                  _infoTile(
                    "Pollution Start",
                    _formatDate(v.pollutionStarts),
                    icon: Icons.fact_check,
                  ),
                  _infoTile(
                    "Pollution End",
                    _formatDate(v.pollutionEnds),
                    icon: Icons.fact_check,
                  ),

                  _sectionTitle("Other Info"),
                  _infoTile("Service KM", v.serviceKm, icon: Icons.speed),
                  _infoTile(
                    "Battery",
                    v.battery ?? "N/A",
                    icon: Icons.battery_charging_full,
                  ),
                  _infoTile(
                    "Alignment",
                    v.alignment ?? "N/A",
                    icon: Icons.tune,
                  ),
                  _infoTile("Notes", v.notes ?? "No Notes", icon: Icons.note),

                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text("Need Notifications"),
                    subtitle: const Text(
                      "Enable reminders for services & insurance",
                    ),
                    value: v.needNotification,
                    onChanged: null, // readonly
                  ),
                  SwitchListTile(
                    title: const Text("Shared With Others"),
                    subtitle: const Text(
                      "Allow other users to view this vehicle",
                    ),
                    value: v.sharedWith,
                    onChanged: null, // readonly
                  ),
                ],
              ),
            ),
    );
  }
}
