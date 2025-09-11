import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/screens/vehicle/add_vehicle.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  late Future<List<VehicleModel>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    _vehiclesFuture = context.read<VehicleProvider>().fetchVehicles();
  }

  String formatDate(DateTime? dt) =>
      dt != null ? "${dt.toLocal().toString().split(' ')[0]}" : "N/A";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Vehicles")),
      body: FutureBuilder<List<VehicleModel>>(
        future: _vehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final vehicles = snapshot.data ?? [];

          if (vehicles.isEmpty) {
            return const Center(child: Text("No vehicles found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final v = vehicles[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehicle ID: ${v.vehicleId}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Owner: ${v.ownerName}"),
                      Text("Vehicle: ${v.vehicleName} (${v.vehicleYear})"),
                      Text("Number: ${v.vehicleNumber}"),
                      Text("Service KM: ${v.serviceKm}"),
                      Text("Insurance: ${formatDate(v.insuranceStarts)} - ${formatDate(v.insuranceEnds)}"),
                      Text("Pollution: ${formatDate(v.pollutionStarts)} - ${formatDate(v.pollutionEnds)}"),
                      Text("Battery: ${v.battery ?? 'N/A'}"),
                      Text("Alignment: ${v.alignment ?? 'N/A'}"),
                      Text("Notes: ${v.notes ?? 'N/A'}"),
                      Text("Need Notification: ${v.needNotification ? "Yes" : "No"}"),
                      Text("Shared With: ${v.sharedWith ? "Yes" : "No"}"),
                      Text("Uploaded By: ${v.vehicleAddedBy}"),
                      Text("Created At: ${formatDate(v.createdAt)}"),
                      Text("Uploaded At: ${formatDate(v.uploadedAt)}"),
                      if (v.imageUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.network(v.imageUrl!, height: 100, fit: BoxFit.cover),
                        ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Navigate to AddVehiclePage with the vehicle to edit
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddVehiclePage(vehicle: v),
                              ),
                            );

                            // If edited, refresh the list
                            if (result == true) {
                              setState(() => _loadVehicles());
                            }
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
