class User {
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.fullName,
      this.email,
      this.password,
      this.role = 'user',
      this.accessToken,
      this.refreshToken,
      this.createdAt});
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? email;
  final String? password;
  final String? role;
  final String? createdAt;
  final String? accessToken;
  final String? refreshToken;
  User copyWith(
      {int? id,
      String? firstName,
      String? lastName,
      String? fullName,
      String? email,
      String? password,
      String? role,
      String? refreshToken,
      String? accessToken,
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
        accessToken: accessToken ?? this.refreshToken,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "fullName": fullName,
      "email": email,
      "password": password,
      "createdAt": createdAt,
      "role": role,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      createdAt: json['createdAt'],
      email: json['email'],
      password: json['password'],
      refreshToken: json['refreshToken'],
      accessToken: json['accessToken'],
      role: json['role'] == Role.admin.name ? 'admin' : 'user',
    );
  }

  @override
  String toString() {
    return 'User{id=$id, firstName=$firstName, lastName=$lastName, fullName=$fullName, email=$email, password=$password, role=$role, createdAt=$createdAt, accessToken=$accessToken, refreshToken=$refreshToken}';
  }
}

enum Role { admin, user }

extension on Role {
  get getValue {
    return name;
  }
}
