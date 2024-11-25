import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {this.id,
      this.firstName,
      this.lastName,
      this.fullName,
      this.email,
      this.password,
      this.role = 'user',
      this.accessToken,
      this.refreshToken,
      this.dob,
      this.createdAt});

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? email;
  final String? password;
  final String? role;
  final String? createdAt;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? dob;

  User copyWith(
      {String? id,
      String? firstName,
      String? lastName,
      String? fullName,
      String? email,
      String? password,
      String? role,
      String? refreshToken,
      String? accessToken,
      DateTime? dob,
      String? createdAt}) {
    return User(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
        refreshToken: refreshToken ?? this.refreshToken,
        accessToken: accessToken ?? this.accessToken,
        dob: dob ?? this.dob,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "firstName": firstName,
      "lastName": lastName,
      "fullName": fullName,
      "email": email,
      "password": password,
      "createdAt": createdAt,
      "role": role,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "dob": dob?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['name'],
      createdAt: json['createdAt'],
      email: json['email'],
      password: json['password'],
      refreshToken: json['refreshToken'],
      accessToken: json['accessToken'],
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
      // role: json['role'] == Role.admin.name ? 'admin' : 'user',
    );
  }

  @override
  String toString() {
    return 'User{id=$id, firstName=$firstName, lastName=$lastName, fullName=$fullName, email=$email, password=$password, role=$role, createdAt=$createdAt, accessToken=$accessToken, refreshToken=$refreshToken, dob=$dob}';
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        firstName,
        createdAt,
        email,
        password,
        refreshToken,
        accessToken,
        dob
      ];
}

enum Role {
  admin('admin'),
  user('user');

  final String name;

  const Role(this.name);
}
