class VehicleModel {
  final String vehicleId;           // unique text ID
  final String ownerName;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleYear;

  // Optional fields
  final DateTime? createdAt;
  final DateTime? uploadedAt;
  final DateTime? insuranceStarts;
  final DateTime? insuranceEnds;
  final DateTime? pollutionStarts;
  final DateTime? pollutionEnds;
  final String? battery;
  final String? alignment;
  final String serviceKm;
  final String? notes;
  final bool needNotification;
  final bool sharedWith;
  final String? imageUrl;

  final String userAuthUuid;        // who added
  final String vehicleAddedBy;      // name/email of user

  VehicleModel({
    required this.vehicleId,
    required this.ownerName,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleYear,
    required this.userAuthUuid,
    required this.vehicleAddedBy,
    required this.serviceKm,
    this.createdAt,
    this.uploadedAt,
    this.insuranceStarts,
    this.insuranceEnds,
    this.pollutionStarts,
    this.pollutionEnds,
    this.battery,
    this.alignment,
    this.notes,
    this.needNotification = false,
    this.sharedWith = false,
    this.imageUrl,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleId: json['vehicle_id'],
      ownerName: json['owner_name'],
      vehicleName: json['vehicle_name'],
      vehicleNumber: json['vehicle_number'],
      vehicleYear: json['vehicle_year'],
      userAuthUuid: json['user_auth_uuid'],
      vehicleAddedBy: json['vehicle_added_by'],
      serviceKm: json['service_km'] ?? "0",
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      uploadedAt: json['uploaded_at'] != null ? DateTime.parse(json['uploaded_at']) : null,
      insuranceStarts: json['insurance_starts'] != null ? DateTime.parse(json['insurance_starts']) : null,
      insuranceEnds: json['insurance_ends'] != null ? DateTime.parse(json['insurance_ends']) : null,
      pollutionStarts: json['pollution_starts'] != null ? DateTime.parse(json['pollution_starts']) : null,
      pollutionEnds: json['pollution_ends'] != null ? DateTime.parse(json['pollution_ends']) : null,
      battery: json['battery'],
      alignment: json['alignment'],
      notes: json['notes'],
      needNotification: json['need_notification'] ?? false,
      sharedWith: json['shared_with'] ?? false,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'owner_name': ownerName,
      'vehicle_name': vehicleName,
      'vehicle_number': vehicleNumber,
      'vehicle_year': vehicleYear,
      'user_auth_uuid': userAuthUuid,
      'vehicle_added_by': vehicleAddedBy,
      'service_km': serviceKm,
      'created_at': createdAt?.toIso8601String(),
      'insurance_starts': insuranceStarts?.toIso8601String(),
      'insurance_ends': insuranceEnds?.toIso8601String(),
      'pollution_starts': pollutionStarts?.toIso8601String(),
      'pollution_ends': pollutionEnds?.toIso8601String(),
      'battery': battery,
      'alignment': alignment,
      'notes': notes,
      'need_notification': needNotification,
      'shared_with': sharedWith,
      'image_url': imageUrl,
      // uploaded_at is handled by DB default
    };
  }
}
