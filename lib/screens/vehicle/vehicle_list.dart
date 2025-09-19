import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';
import 'package:wheelbase/screens/vehicle/add_vehicle.dart';
import 'package:wheelbase/themes/app/appbar.dart';
import 'package:wheelbase/themes/app/apploaders.dart';
import 'package:wheelbase/themes/app/snackbars.dart';
import 'package:wheelbase/utils/date_utils.dart';

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

  Future<void> _refreshVehicles() async {
    setState(() {
      _vehiclesFuture = context.read<VehicleProvider>().fetchVehicles();
    });
    await _vehiclesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        titleText: "My Vehicles",
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshVehicles,
          ),
        ],
      ),
      body: FutureBuilder<List<VehicleModel>>(
        future: _vehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }

          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppSnackBar.show(context, "Error: ${snapshot.error}");
            });
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final vehicles = snapshot.data ?? [];

          if (vehicles.isEmpty) {
            return const Center(child: Text("No vehicles found."));
          }

          return RefreshIndicator(
            onRefresh: _refreshVehicles,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final v = vehicles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddVehiclePage(vehicle: v, isEditing: false),
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
                                "Insurance: ${DateUtilsWB.formatDate(v.insuranceStarts)} → ${DateUtilsWB.formatDate(v.insuranceEnds)}",
                              ),
                              Text(
                                "Pollution: ${DateUtilsWB.formatDate(v.pollutionStarts)} → ${DateUtilsWB.formatDate(v.pollutionEnds)}",
                              ),
                              const Divider(),
                              Text("Notes: ${v.notes ?? 'N/A'}"),
                              Text("Shared: ${v.sharedWith ? "Yes" : "No"}"),
                              Text(
                                "Notification: ${v.needNotification ? "On" : "Off"}",
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddVehiclePage(
                                          vehicle: v,
                                          isEditing: true,
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
