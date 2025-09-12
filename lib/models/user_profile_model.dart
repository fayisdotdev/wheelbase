// // models/user_profile_model.dart
class UserProfileModel {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String authUuid;
  final String uuid;
  final DateTime createdAt;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.authUuid,
    required this.uuid,
    required this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      authUuid: json['auth_uuid'] as String,
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
