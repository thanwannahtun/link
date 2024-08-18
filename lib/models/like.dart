import 'package:equatable/equatable.dart';
import 'package:link/models/user.dart';

class Like extends Equatable {
  final String? id;
  final User? user;
  final String? post;
  final DateTime? createdAt;

  const Like({this.id, this.user, this.post, this.createdAt});

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json['_id'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        post: json['post'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user?.toJson(),
        'post': post,
        'createdAt': createdAt?.toIso8601String(),
      };

  Like copyWith({
    String? id,
    User? user,
    String? post,
    DateTime? createdAt,
  }) {
    return Like(
      id: id ?? this.id,
      user: user ?? this.user,
      post: post ?? this.post,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, user, post, createdAt];
}
