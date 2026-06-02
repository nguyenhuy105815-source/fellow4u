/// User model - represents app user (traveler)
library;

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String? phone;
  final String? firstName;
  final String? lastName;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.phone,
    this.firstName,
    this.lastName,
  });

  String get fullName {
    final parts = [firstName, lastName]
        .whereType<String>()
        .where((x) => x.isNotEmpty)
        .toList();
    return parts.isEmpty ? displayName : parts.join(' ').trim();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      displayName: (json['display_name'] ??
              json['displayName'] ??
              json['name'] ??
              json['email'] ??
              '')
          .toString(),
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl'])?.toString(),
      phone: json['phone']?.toString(),
      firstName: (json['first_name'] ?? json['firstName'])?.toString(),
      lastName: (json['last_name'] ?? json['lastName'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
      };

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? phone,
    String? firstName,
    String? lastName,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        phone: phone ?? this.phone,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );
}
