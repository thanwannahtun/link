import 'package:equatable/equatable.dart';
import 'package:link/models/user.dart';

class Comment extends Equatable {
  final String? id;
  final User? user;
  final String? post;
  final String? content;
  final DateTime? createdAt;

  const Comment({
    this.id,
    this.user,
    this.post,
    this.content,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['_id'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        post: json['post'] as String?,
        content: json['content'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        // 'user': user?.toJson(),
        'user': user?.id,
        // 'post': post,
        'post': post,
        'content': content,
        'createdAt': createdAt?.toIso8601String(),
      };

  Comment copyWith({
    String? id,
    User? user,
    String? post,
    String? content,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      user: user ?? this.user,
      post: post ?? this.post,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, user, post, content, createdAt];
}
