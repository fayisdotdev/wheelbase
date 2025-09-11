import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheelbase/models/vehicles_model.dart';

class VehicleProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  Future<bool> addVehicle(VehicleModel vehicle) async {
    try {
      await supabase.from("vehicles").insert(vehicle.toJson());
      return true;
    } catch (e) {
      debugPrint("Error adding vehicle: $e");
      return false;
    }
  }

  Future<String?> uploadImage(File file) async {
    try {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      await supabase.storage.from('vehicle-images').upload(fileName, file);
      return supabase.storage.from('vehicle-images').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Image upload failed: $e");
      return null;
    }
  }

  Future<List<VehicleModel>> fetchVehicles() async {
    try {
      final response = await supabase.from('vehicles').select().order('uploaded_at', ascending: false);
      final List data = response as List;
      return data.map((e) {
        return VehicleModel(
          // id: e['id'],
          vehicleId: e['vehicle_id'],
          ownerName: e['owner_name'],
          vehicleName: e['vehicle_name'],
          vehicleNumber: e['vehicle_number'],
          vehicleYear: e['vehicle_year'],
          insuranceStarts: DateTime.parse(e['insurance_starts']),
          insuranceEnds: DateTime.parse(e['insurance_ends']),
          pollutionStarts: DateTime.parse(e['pollution_starts']),
          pollutionEnds: DateTime.parse(e['pollution_ends']),
          serviceKm: e['service_km'],
          battery: e['battery'],
          alignment: e['alignment'],
          notes: e['notes'],
          needNotification: e['need_notification'],
          sharedWith: e['shared_with'],
          vehicleAddedBy: e['vehicle_added_by'],
          imageUrl: e['image_url'],
          userAuthUuid: e['user_auth_uuid'],
          // uploadedAt: DateTime.parse(e['uploaded_at']),
        );
      }).toList();
    } catch (e) {
      debugPrint("Error fetching vehicles: $e");
      return [];
    }
  }
}
