import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';
import 'package:wheelbase/screens/vehicle/add_vehicle.dart';
// import 'package:wheelbase/screens/vehicle/detailed_page.dart'; // Import the detailed page

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
      appBar: AppBar(
        title: const Text("My Vehicles"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              _loadVehicles();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔄 Vehicles reloaded')),
              );
            },
          ),
        ],
      ),
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

          return RefreshIndicator(
            onRefresh: () async {
              _loadVehicles();
              await _vehiclesFuture;
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final v = vehicles[index];

                return GestureDetector(
                  // user clicked the whole card
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddVehiclePage(
                          vehicle: v,
                          isEditing: false, // 👈 start in read-only mode
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Vehicle image
                        if (v.imageUrl != null && v.imageUrl!.isNotEmpty)
                          FutureBuilder<String?>(
                            future: context
                                .read<VehicleProvider>()
                                .getSignedImageUrl(
                                  v.imageUrl!.replaceFirst(
                                    RegExp(r'^.*vehicle-images2/'),
                                    '',
                                  ),
                                ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 160,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (snapshot.hasError || snapshot.data == null) {
                                return Container(
                                  height: 160,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(
                                      Icons.directions_car,
                                      size: 64,
                                      color: Colors.black54,
                                    ),
                                  ),
                                );
                              }
                              return Image.network(
                                snapshot.data!,
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        else
                          Container(
                            height: 160,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.directions_car,
                                size: 64,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                        // 🔹 Vehicle info
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${v.vehicleName} (${v.vehicleYear})",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text("Owner: ${v.ownerName}"),
                              Text("Number: ${v.vehicleNumber}"),
                              const Divider(),
                              Text("Service Km: ${v.serviceKm}"),
                              Text("Battery: ${v.battery ?? 'N/A'}"),
                              Text("Alignment: ${v.alignment ?? 'N/A'}"),
                              const Divider(),
                              Text(
                                "Insurance: ${formatDate(v.insuranceStarts)} → ${formatDate(v.insuranceEnds)}",
                              ),
                              Text(
                                "Pollution: ${formatDate(v.pollutionStarts)} → ${formatDate(v.pollutionEnds)}",
                              ),
                              const Divider(),
                              Text("Notes: ${v.notes ?? 'N/A'}"),
                              Text("Shared: ${v.sharedWith ? "Yes" : "No"}"),
                              Text(
                                "Notification: ${v.needNotification ? "On" : "Off"}",
                              ),
                              const SizedBox(height: 8),

                              // 🔹 Edit button
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  // pressed edit
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddVehiclePage(
                                          vehicle: v,
                                          isEditing:
                                              true, // 👈 start directly in edit mode
                                        ),
                                      ),
                                    );

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
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
