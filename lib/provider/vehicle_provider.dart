import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wheelbase/models/vehicles_model.dart';

class VehicleProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  Future<String?> uploadImage(File file) async {
    try {
      final fileName = "${const Uuid().v4()}.jpg";
      await supabase.storage.from('vehicle-images').upload(fileName, file);
      return supabase.storage.from('vehicle-images').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Image upload error: $e");
      return null;
    }
  }

  Future<bool> addVehicle(VehicleModel vehicle) async {
    try {
      await supabase.from("vehicles").insert(vehicle.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error adding vehicle: $e");
      return false;
    }
  }
}
