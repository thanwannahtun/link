import 'package:link/models/user.dart';

class Agency {
  Agency({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.profileImage,
    this.contactInfo,
    this.address,
    this.createdAt,
  });

  final String? id;
  final User? userId;
  final String? name;
  final String? description;
  final String? profileImage;
  final String? contactInfo;
  final String? address;
  final DateTime? createdAt;

  Agency copyWith({
    String? id,
    User? userId,
    String? name,
    String? description,
    String? profileImage,
    String? contactInfo,
    String? address,
    DateTime? createdAt,
  }) {
    return Agency(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      contactInfo: contactInfo ?? this.contactInfo,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "name": name,
      "description": description,
      "profile_image": profileImage,
      "contactInfo": contactInfo,
      "address": address,
      "createdAt": createdAt,
    };
  }

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['_id'],
      userId: json['user_id'] == null
          ? null
          : User.fromJson(json['user_id'] as Map<String, dynamic>),
      name: json['name'],
      description: json['description'],
      profileImage: json['profile_image']
      // ?? "https://www.shutterstock.com/image-vector/travel-logo-agency-260nw-2274032709.jpg"
      ,
      contactInfo: json['contactInfo'],
      address: json['address'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  @override
  String toString() {
    return 'Agency{_id=$id, userId=$userId, name=$name, description=$description, profileImage=$profileImage, contactInfo=$contactInfo, address=$address, createdAt=$createdAt}';
  }
}
