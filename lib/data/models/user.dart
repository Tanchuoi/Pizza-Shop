class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final String birthDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.birthDate,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? birthDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
      'birthDate': birthDate,
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      birthDate: map['birthDate'],
    );
  }
}
