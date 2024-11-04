import 'package:link/models/user.dart';

import 'package:link/ui/sections/profile/setting_screen.dart';

class Agency {
  Agency({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.profileImage,
    this.coverImage,
    this.contactInfo,
    this.address,
    this.location,
    this.services,
    this.averageRating,
    this.reviews,
    this.gallery,
    this.socialMediaLinks,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final User? userId; // Reference to the owner (Agency User)
  final String? name;
  final String? description;
  final String? profileImage; // Profile picture URL
  final String? coverImage; // Cover image for the agency
  final String? contactInfo; // Contact details like phone, email
  final String? address;
  final Map<String, double>? location; // Geolocation with lat and lon
  final List<Service>? services; // List of services offered by the agency
  final double? averageRating; // Average rating based on reviews
  final List<Review>? reviews; // List of reviews from users
  final List<String>? gallery; // Gallery with image URLs
  final SocialMediaLinks? socialMediaLinks; // Social media links
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Agency copyWith({
    String? id,
    User? userId,
    String? name,
    String? description,
    String? profileImage,
    String? coverImage,
    String? contactInfo,
    String? address,
    Map<String, double>? location,
    List<Service>? services,
    double? averageRating,
    List<Review>? reviews,
    List<String>? gallery,
    SocialMediaLinks? socialMediaLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Agency(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      contactInfo: contactInfo ?? this.contactInfo,
      address: address ?? this.address,
      location: location ?? this.location,
      services: services ?? this.services,
      averageRating: averageRating ?? this.averageRating,
      reviews: reviews ?? this.reviews,
      gallery: gallery ?? this.gallery,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "name": name,
      "description": description,
      "profile_image": profileImage,
      "cover_image": coverImage,
      "contactInfo": contactInfo,
      "address": address,
      "location": location,
      "services": services?.map((e) => e.toJson()).toList(),
      "averageRating": averageRating,
      "reviews": reviews?.map((e) => e.toJson()).toList(),
      "gallery": gallery,
      "socialMediaLinks": socialMediaLinks?.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['_id'],
      // userId: json['user_id'] == null
      //     ? null
      //     : User.fromJson(json['user_id'] as Map<String, dynamic>),
      name: json['name'],
      description: json['profile_description'],
      profileImage: json['profile_image'],
      coverImage: json['cover_image'],
      contactInfo: json['contactInfo'],
      address: json['address'],
      location: Map<String, double>.from(json['location'] ?? {}),
      services: json['services'] != null
          ? List<Service>.from(json['services'].map((x) => Service.fromJson(x)))
          : null,
      averageRating: json['averageRating']?.toDouble(),
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
          : null,
      gallery: List<String>.from(json['gallery'] ?? []),
      socialMediaLinks: json['socialMediaLinks'] != null
          ? SocialMediaLinks.fromJson(json['socialMediaLinks'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  @override
  String toString() {
    return 'Agency{id: $id, userId: $userId, name: $name, description: $description, profileImage: $profileImage, coverImage: $coverImage, contactInfo: $contactInfo, address: $address, location: $location, services: $services, averageRating: $averageRating, reviews: $reviews, gallery: $gallery, socialMediaLinks: $socialMediaLinks, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class Service {
  Service({this.id, this.title, this.description, this.imageUrl});

  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Review {
  Review({this.id, this.username, this.rating, this.reviewText});

  final String? id;
  final String? username;
  final double? rating;
  final String? reviewText;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "rating": rating,
      "reviewText": reviewText,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      username: json['username'],
      rating: json['rating']?.toDouble(),
      reviewText: json['reviewText'],
    );
  }
}

class SocialMediaLinks {
  SocialMediaLinks({this.facebook, this.instagram, this.twitter});

  final String? facebook;
  final String? instagram;
  final String? twitter;

  Map<String, dynamic> toJson() {
    return {
      "facebook": facebook,
      "instagram": instagram,
      "twitter": twitter,
    };
  }

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) {
    return SocialMediaLinks(
      facebook: json['facebook'],
      instagram: json['instagram'],
      twitter: json['twitter'],
    );
  }
}
/*
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
  // final String? userId;
  final String? name;
  final String? description;
  final String? profileImage;
  final String? contactInfo;
  final String? address;
  final DateTime? createdAt;

  Agency copyWith({
    String? id,
    User? userId,
    // String? userId,
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
  /*
  
    agency: {
    _id: new ObjectId('66b8d28d3e1a9b47a2c0e69c'),
    name: 'Asia World',
    profile_description: 'Best travel agency for exotic locations with Fun Moments!',
    profile_image: 'https://images.pexels.com/photos/3278215/pexels-photo-3278215.jpeg?auto=compress&cs=tinysrgb&w=600',
    location: Map(2) { 'lat' => 123.123, 'lon' => 456.456 },
    user_id: new ObjectId('66b8d1926d7f679dbf20c73c'),
    createdAt: 2024-08-11T15:02:37.065Z,
    updatedAt: 2024-08-11T15:02:37.065Z,
    __v: 0
  },
   */

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['_id'],
      userId: json['user_id'] == null
          ? null
          : User.fromJson(json['user_id'] as Map<String, dynamic>),
      // userId: json['user_id'],
      name: json['name'],
      description: json['profile_description'],
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

*/
