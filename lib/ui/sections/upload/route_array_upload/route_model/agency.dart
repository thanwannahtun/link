import 'package:equatable/equatable.dart';

import 'location.dart';

class Agency extends Equatable {
  final String? id;
  final String? name;
  final String? profileDescription;
  final String? profileImage;
  final Location? location;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  const Agency({
    this.id,
    this.name,
    this.profileDescription,
    this.profileImage,
    this.location,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        profileDescription: json['profile_description'] as String?,
        profileImage: json['profile_image'] as String?,
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        userId: json['user_id'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'profile_description': profileDescription,
        'profile_image': profileImage,
        'location': location?.toJson(),
        'user_id': userId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  Agency copyWith({
    String? id,
    String? name,
    String? profileDescription,
    String? profileImage,
    Location? location,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Agency(
      id: id ?? this.id,
      name: name ?? this.name,
      profileDescription: profileDescription ?? this.profileDescription,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      profileDescription,
      profileImage,
      location,
      userId,
      createdAt,
      updatedAt,
      v,
    ];
  }
}
