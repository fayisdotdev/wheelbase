class VehicleModel {
  final String id;
  final String vehicleId;
  final String ownerName;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleYear;
  final DateTime insuranceStarts;
  final DateTime insuranceEnds;
  final DateTime pollutionStarts;
  final DateTime pollutionEnds;
  final String serviceKm;
  final String? battery;
  final String? alignment;
  final String? notes;
  final bool needNotification;
  final bool sharedWith;
  final String vehicleAddedBy; // uploader
  final String? imageUrl;
  final String userAuthUuid;
  final DateTime uploadedAt;

  VehicleModel({
    required this.id,
    required this.vehicleId,
    required this.ownerName,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleYear,
    required this.insuranceStarts,
    required this.insuranceEnds,
    required this.pollutionStarts,
    required this.pollutionEnds,
    required this.serviceKm,
    this.battery,
    this.alignment,
    this.notes,
    required this.needNotification,
    required this.sharedWith,
    required this.vehicleAddedBy,
    this.imageUrl,
    required this.userAuthUuid,
    required this.uploadedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'owner_name': ownerName,
      'vehicle_name': vehicleName,
      'vehicle_number': vehicleNumber,
      'vehicle_year': vehicleYear,
      'insurance_starts': insuranceStarts.toIso8601String(),
      'insurance_ends': insuranceEnds.toIso8601String(),
      'pollution_starts': pollutionStarts.toIso8601String(),
      'pollution_ends': pollutionEnds.toIso8601String(),
      'service_km': serviceKm,
      'battery': battery,
      'alignment': alignment,
      'notes': notes,
      'need_notification': needNotification,
      'shared_with': sharedWith,
      'vehicle_added_by': vehicleAddedBy,
      'image_url': imageUrl,
      'user_auth_uuid': userAuthUuid,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}
