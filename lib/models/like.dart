class Like {
  Like({this.userId, this.commentedAt});

  final int? userId;
  final int? commentedAt;

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      userId: json['userId'],
      commentedAt: json['commentedAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {"userId": userId, "commentedAt": commentedAt};
  }

  Like copyWith({int? userId, int? commentedAt}) {
    return Like(
        userId: userId ?? this.userId,
        commentedAt: commentedAt ?? this.commentedAt);
  }
}
