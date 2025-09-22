import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/models/vehicles_model.dart';
import 'package:wheelbase/provider/vehicle_provider.dart';
import 'package:wheelbase/screens/vehicle/edit_vehicle_page.dart';
import 'package:wheelbase/screens/vehicle/view_vehicle_page.dart';

class VehicleListPage extends StatefulWidget {
  final String searchQuery; 

  const VehicleListPage({super.key, this.searchQuery = ""});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  late Future<List<VehicleModel>> _vehiclesFuture;
  List<VehicleModel> _allVehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    _vehiclesFuture = context.read<VehicleProvider>().fetchVehicles();
  }

  // --- Date range formatter ---
  String formatDateRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return "Not Set";
    final startStr = start != null ? "${start.toLocal().toString().split(' ')[0]}" : "Not Set";
    final endStr = end != null ? "${end.toLocal().toString().split(' ')[0]}" : "Not Set";

    // Only show once if both are null
    if (start == null) return "Not Set → $endStr";
    if (end == null) return "$startStr → Not Set";

    return "$startStr → $endStr";
  }

  // --- Filter vehicles based on search query ---
  List<VehicleModel> _filterVehicles() {
    if (widget.searchQuery.isEmpty) return _allVehicles;

    final query = widget.searchQuery.toLowerCase();
    return _allVehicles.where((v) {
      return v.vehicleName.toLowerCase().contains(query) ||
          v.vehicleNumber.toLowerCase().contains(query) ||
          v.vehicleYear.toLowerCase().contains(query) ||
          (v.ownerName.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VehicleModel>>(
      future: _vehiclesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        _allVehicles = snapshot.data ?? [];
        final vehicles = _filterVehicles();

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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewVehiclePage(
                        vehicle: v,
                        // isEditing: false, // start in read-only mode
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
                      // Vehicle Image
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
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

                      // Vehicle Info
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
                            Text("Number: ${v.vehicleNumber}"),
                            const Divider(),
                            Text("Service KM: ${v.serviceKm}"),
                            Text("Battery: ${v.battery ?? 'N/A'}"),
                            Text("Alignment: ${v.alignment ?? 'N/A'}"),
                            const Divider(),
                            Text(
                              "Insurance: ${formatDateRange(v.insuranceStarts, v.insuranceEnds)}",
                            ),
                            Text(
                              "Pollution: ${formatDateRange(v.pollutionStarts, v.pollutionEnds)}",
                            ),
                            const Divider(),
                            Text("Notes: ${v.notes ?? 'No Notes'}"),
                            // Text("Shared: ${v.sharedWith ? "Yes" : "No"}"),
                            // Text(
                            //   "Notification: ${v.needNotification ? "On" : "Off"}",
                            // ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditVehiclePage(
                                        vehicle: v,
                                        // isEditing: true,
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
    );
  }
}
