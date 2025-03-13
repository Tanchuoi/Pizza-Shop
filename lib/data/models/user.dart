class User {
  final String? id;
  final String fullName;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final String? avatar;

  User(
      {this.id,
      required this.username,
      required this.fullName,
      required this.email,
      this.phoneNumber,
      this.address,
      this.birthDate,
      this.avatar});

  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? phoneNumber,
    String? address,
    String? birthDate,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'birthDate': birthDate,
    };

    return data;
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'] ?? '',
      username: map['username'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      birthDate: map['birthDate'],
    );
  }
}
