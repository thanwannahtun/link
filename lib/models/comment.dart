class Comment {
  Comment({this.id, this.userId, this.content, this.createdAt});
  final int? id;
  final int? userId;
  final String? content;
  final DateTime? createdAt;

  Comment copyWith(
      {int? id, int? userId, String? content, DateTime? createdAt}) {
    return Comment(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt);
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        userId: json['userId'],
        createdAt: json['createdAt'],
        content: json['content'],
        id: json['id']);
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "createdAt": createdAt,
      "id": id,
      "content": content
    };
  }
}
