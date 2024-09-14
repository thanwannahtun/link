import 'package:link/models/agency.dart';
import 'package:link/models/city.dart';
import 'package:link/models/comment.dart';
import 'package:link/models/like.dart';
import 'package:link/models/midpoint.dart';
import 'package:link/models/seat.dart';

class Post {
  Post(
      {this.id,
      this.agency,
      this.origin,
      this.destination,
      this.scheduleDate,
      this.pricePerTraveler,
      this.seats,
      this.createdAt,
      this.midpoints,
      this.commentCounts,
      this.likeCounts,
      this.shareCounts,
      this.comments,
      this.likes,
      this.title,
      this.description,
      this.images});

  final String? id;
  final Agency? agency;
  final City? origin;
  final City? destination;
  final DateTime? scheduleDate;
  final double? pricePerTraveler;
  final List<Seat>? seats;
  final DateTime? createdAt;
  final List<Midpoint>? midpoints;
  final int? commentCounts;
  final int? likeCounts;
  final int? shareCounts;
  final List<Comment>? comments;
  final List<Like>? likes;
  final String? title;
  final String? description;
  final List<String>? images;

  Map<String, dynamic> toJson() {
    return {
      // "_id": id,
      // "agency": agency?.toJson(),
      "agency": agency?.id,
      // "origin": origin?.toJson(),
      "origin": origin?.id,
      // "destination": destination?.toJson(),
      "destination": destination?.id,
      "scheduleDate": scheduleDate?.toIso8601String(),
      "pricePerTraveler": pricePerTraveler,
      // "seats": seats?.map((e) => e.toJson()).toList(),
      // "createdAt": createdAt?.toIso8601String(),
      // "midpoints": midpoints?.map((e) => e.toJson()),
      "commentCounts": commentCounts,
      "likeCounts": likeCounts,
      "shareCounts": shareCounts,
      "title": title,
      // "images": images,
      "images": [],
      "description": description,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      agency: json['agency'] != null
          ? Agency.fromJson(json['agency'] as Map<String, dynamic>)
          : null,
      origin: json['origin'] != null
          ? City.fromJson(json['origin'] as Map<String, dynamic>)
          : null,
      destination: json['destination'] != null
          ? City.fromJson(json['destination'] as Map<String, dynamic>)
          : null,
      scheduleDate: DateTime.parse(json['scheduleDate'] ?? ""),
      pricePerTraveler: (json['pricePerTraveler'] as num).toDouble(),
      seats: (json['seats'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      midpoints: (json['midpoints'] as List<dynamic>?)
          ?.map((e) => Midpoint.fromJson(e))
          .toList(),
      commentCounts: json['commentCounts'],
      likeCounts: json['likeCounts'],
      shareCounts: json['shareCounts'],
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => Like.fromJson(e))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e))
          .toList(),
      images: (json['images'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
    );
  }

  Post copyWith(
      {String? id,
      Agency? agency,
      String? title,
      String? description,
      City? origin,
      City? destination,
      DateTime? scheduleDate,
      double? pricePerTraveler,
      List<Seat>? seats,
      DateTime? createdAt,
      List<Midpoint>? midpoints,
      int? commentCounts,
      int? likeCounts,
      int? shareCounts,
      List<Comment>? comments,
      List<String>? images,
      List<Like>? likes}) {
    return Post(
        id: id ?? id,
        agency: agency ?? this.agency,
        title: title ?? this.title,
        description: description ?? this.title,
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        scheduleDate: scheduleDate ?? this.scheduleDate,
        pricePerTraveler: pricePerTraveler ?? this.pricePerTraveler,
        seats: seats ?? this.seats,
        createdAt: createdAt ?? this.createdAt,
        midpoints: midpoints ?? this.midpoints,
        commentCounts: commentCounts ?? this.commentCounts,
        likeCounts: likeCounts ?? this.likeCounts,
        shareCounts: shareCounts ?? this.shareCounts,
        comments: comments ?? this.comments,
        images: images ?? this.images,
        likes: likes ?? this.likes);
  }

  @override
  String toString() {
    return 'PostRoute{_id=$id, agency=$agency, origin=$origin, destination=$destination, scheduleDate=$scheduleDate, pricePerTraveler=$pricePerTraveler, seats=$seats, createdAt=$createdAt, midpoints=$midpoints, commentCounts=$commentCounts, likeCounts=$likeCounts, shareCounts=$shareCounts, comments=$comments, likes=$likes, title=$title, description=$description ,images=$images}';
  }
}
