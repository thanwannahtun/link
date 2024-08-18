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
      role: json['role'] == Role.admin.name ? 'admin' : 'user',
    );
  }

  @override
  String toString() {
    return 'User{id=$id, firstName=$firstName, lastName=$lastName, fullName=$fullName, email=$email, password=$password, role=$role, createdAt=$createdAt, accessToken=$accessToken, refreshToken=$refreshToken}';
  }
}

enum Role {
  admin('admin'),
  user('user');

  final String name;
  const Role(this.name);
}
