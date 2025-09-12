import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheelbase/models/vehicles_model.dart';

class VehicleProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  Future<bool> addVehicle(VehicleModel vehicle) async {
    try {
      debugPrint("Adding vehicle: ${vehicle.toJson()}");
      final response = await supabase.from("vehicles").insert(vehicle.toJson());
      debugPrint("Add vehicle response: $response");
      return true;
    } catch (e, stack) {
      debugPrint("Error adding vehicle: $e\n$stack");
      return false;
    }
  }

  Future<bool> updateVehicle(VehicleModel vehicle) async {
    try {
      debugPrint("Updating vehicle: ${vehicle.toJson()}");
      final response = await supabase
          .from("vehicles")
          .update(vehicle.toJson())
          .eq("vehicle_id", vehicle.vehicleId);
      debugPrint("Update vehicle response: $response");
      notifyListeners();
      return true;
    } catch (e, stack) {
      debugPrint("Error updating vehicle: $e\n$stack");
      return false;
    }
  }

  Future<String?> uploadImage(File file) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint("No user found for image upload.");
        return null;
      }

      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      final filePath = "${user.id}/$fileName";

      debugPrint("Uploading image to: $filePath");
      await supabase.storage
          .from('vehicle-images2')
          .upload(
            filePath,
            file,
            fileOptions: FileOptions(cacheControl: '3600', upsert: false),
          );

      final publicUrl = supabase.storage
          .from('vehicle-images2')
          .getPublicUrl(filePath);
      debugPrint("Image uploaded. Public URL: $publicUrl");
      return publicUrl;
    } catch (e, stack) {
      debugPrint("Image upload failed: $e\n$stack");
      return null;
    }
  }

  Future<List<VehicleModel>> fetchVehicles() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        debugPrint("No user found for fetching vehicles.");
        return [];
      }

      debugPrint("Fetching vehicles for user: ${user.id}");
      final response = await supabase
          .from('vehicles')
          .select()
          .eq('vehicle_added_by', user.id)
          .order('uploaded_at', ascending: false);

      debugPrint("Fetch vehicles response: $response");

      return response.map((e) => VehicleModel.fromJson(e)).toList();
    } catch (e, stack) {
      debugPrint("Error fetching vehicles: $e\n$stack");
      return [];
    }
  }

  // In VehicleProvider, add a method:
  Future<String?> getSignedImageUrl(String path) async {
    try {
      final res = await supabase.storage
          .from('vehicle-images2')
          .createSignedUrl(path, 60 * 60);
      return res;
    } catch (e) {
      debugPrint("Error getting signed URL: $e");
      return null;
    }
  }
}
