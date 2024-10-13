// import 'package:link/models/user.dart';
// import 'package:link/ui/sections/profile/setting_screen.dart';

// class AgencyModel {
//   AgencyModel({
//     this.id,
//     this.userId,
//     this.name,
//     this.description,
//     this.profileImage,
//     this.coverImage,
//     this.contactInfo,
//     this.address,
//     this.location,
//     this.services,
//     this.averageRating,
//     this.reviews,
//     this.gallery,
//     this.socialMediaLinks,
//     this.createdAt,
//     this.updatedAt,
//   });

//   final String? id;
//   final User? userId; // Reference to the owner (Agency User)
//   final String? name;
//   final String? description;
//   final String? profileImage; // Profile picture URL
//   final String? coverImage; // Cover image for the agency
//   final String? contactInfo; // Contact details like phone, email
//   final String? address;
//   final Map<String, double>? location; // Geolocation with lat and lon
//   final List<Service>? services; // List of services offered by the agency
//   final double? averageRating; // Average rating based on reviews
//   final List<Review>? reviews; // List of reviews from users
//   final List<String>? gallery; // Gallery with image URLs
//   final SocialMediaLinks? socialMediaLinks; // Social media links
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   AgencyModel copyWith({
//     String? id,
//     User? userId,
//     String? name,
//     String? description,
//     String? profileImage,
//     String? coverImage,
//     String? contactInfo,
//     String? address,
//     Map<String, double>? location,
//     List<Service>? services,
//     double? averageRating,
//     List<Review>? reviews,
//     List<String>? gallery,
//     SocialMediaLinks? socialMediaLinks,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return AgencyModel(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       profileImage: profileImage ?? this.profileImage,
//       coverImage: coverImage ?? this.coverImage,
//       contactInfo: contactInfo ?? this.contactInfo,
//       address: address ?? this.address,
//       location: location ?? this.location,
//       services: services ?? this.services,
//       averageRating: averageRating ?? this.averageRating,
//       reviews: reviews ?? this.reviews,
//       gallery: gallery ?? this.gallery,
//       socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "userId": userId,
//       "name": name,
//       "description": description,
//       "profile_image": profileImage,
//       "cover_image": coverImage,
//       "contactInfo": contactInfo,
//       "address": address,
//       "location": location,
//       "services": services?.map((e) => e.toJson()).toList(),
//       "averageRating": averageRating,
//       "reviews": reviews?.map((e) => e.toJson()).toList(),
//       "gallery": gallery,
//       "socialMediaLinks": socialMediaLinks?.toJson(),
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//     };
//   }

//   factory AgencyModel.fromJson(Map<String, dynamic> json) {
//     return AgencyModel(
//       id: json['_id'],
//       userId: json['user_id'] == null
//           ? null
//           : User.fromJson(json['user_id'] as Map<String, dynamic>),
//       name: json['name'],
//       description: json['description'],
//       profileImage: json['profile_image'],
//       coverImage: json['cover_image'],
//       contactInfo: json['contactInfo'],
//       address: json['address'],
//       location: Map<String, double>.from(json['location'] ?? {}),
//       services: json['services'] != null
//           ? List<Service>.from(json['services'].map((x) => Service.fromJson(x)))
//           : null,
//       averageRating: json['averageRating']?.toDouble(),
//       reviews: json['reviews'] != null
//           ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
//           : null,
//       gallery: List<String>.from(json['gallery'] ?? []),
//       socialMediaLinks: json['socialMediaLinks'] != null
//           ? SocialMediaLinks.fromJson(json['socialMediaLinks'])
//           : null,
//       createdAt:
//           json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt:
//           json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }

//   @override
//   String toString() {
//     return 'Agency{id: $id, userId: $userId, name: $name, description: $description, profileImage: $profileImage, coverImage: $coverImage, contactInfo: $contactInfo, address: $address, location: $location, services: $services, averageRating: $averageRating, reviews: $reviews, gallery: $gallery, socialMediaLinks: $socialMediaLinks, createdAt: $createdAt, updatedAt: $updatedAt}';
//   }
// }
