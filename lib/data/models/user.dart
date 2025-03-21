import 'dart:convert';

class User {
  final String? id;
  final String fullName;
  final String? username;
  final String email;
  final String? phoneNumber;
  final String? address;
  final DateTime birthDate;
  final String? avatar;
  final String? gender;

  User(
      {this.id,
      this.username,
      required this.fullName,
      required this.email,
      this.phoneNumber,
      this.address,
      DateTime? birthDate,
      this.gender,
      this.avatar})
      : birthDate = birthDate ?? DateTime.now();

  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? phoneNumber,
    String? address,
    String? birthDate,
    String? gender,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      birthDate: DateTime.parse(birthDate ?? this.birthDate.toIso8601String()),
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'username': username,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
    };

    return data;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
    );
  }
}
