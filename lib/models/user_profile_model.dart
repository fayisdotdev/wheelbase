class UserProfileModel {
  final String authUuid;
  final String uuid;
  final String email;
  final String name;
  final String phone;
  final String password;
  final DateTime createdAt;

  UserProfileModel({
    required this.authUuid,
    required this.uuid,
    required this.email,
    required this.name,
    required this.phone,
    required this.password,
    required this.createdAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      authUuid: map['auth_uuid'] ?? '',
      uuid: map['uuid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  UserProfileModel copyWith({
    String? name,
    String? phone,
    String? password,
  }) {
    return UserProfileModel(
      authUuid: authUuid,
      uuid: uuid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'auth_uuid': authUuid,
      'uuid': uuid,
      'email': email,
      'name': name,
      'phone': phone,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
