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

  Future<bool> updateVehicle(VehicleModel vehicle) async {
    try {
      await supabase
          .from("vehicles")
          .update(vehicle.toJson())
          .eq("vehicle_id", vehicle.vehicleId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error updating vehicle: $e");
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
      final response = await supabase
          .from('vehicles')
          .select()
          .order('uploaded_at', ascending: false);

      final List data = response as List;
      return data.map((e) => VehicleModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching vehicles: $e");
      return [];
    }
  }
}
