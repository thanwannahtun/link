import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import '../../../../../models/agency.dart';
import '../../../../../models/city.dart';

class RouteModel extends Equatable {
  final String? id;
  final Agency? agency;
  final String? post;
  final City? origin;
  final City? destination;
  final DateTime? scheduleDate;
  final double? pricePerTraveller;
  final List<RouteMidpoint>? midpoints;
  final DateTime? createdAt;
  final String? description;
  final bool? isSponsored;

  // final List<dynamic>? seats;
  final String? image;

  const RouteModel(
      {this.id,
      this.agency,
      this.post,
      this.origin,
      this.destination,
      this.scheduleDate,
      this.pricePerTraveller,
      this.midpoints,
      this.createdAt,
      // this.seats,
      this.image,
      this.description,
      this.isSponsored});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    debugPrint("json- $json ----- json");
    return RouteModel(
      id: json['_id'] as String?,
      agency: json['agency'] == null
          ? null
          : Agency.fromJson(json['agency'] as Map<String, dynamic>),
      post: json['post'] as String?,
      origin: json['origin'] == null
          ? null
          : City.fromJson(json['origin'] as Map<String, dynamic>),
      destination: json['destination'] == null
          ? null
          : City.fromJson(json['destination'] as Map<String, dynamic>),
      scheduleDate: json['scheduleDate'] == null
          ? null
          : DateTime.parse(json['scheduleDate'] as String),
      pricePerTraveller:
          double.tryParse(json['pricePerTraveller']?.toString() ?? ""),
      midpoints: (json['midpoints'] as List<dynamic>?)
          ?.map((e) => RouteMidpoint.fromJson(e))
          .toList(),
      // midpoints: json['midpoints'] as List<Midpoint>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      // seats: json['seats'] as List<dynamic>?,
      description: json['description'],
      isSponsored: json['isSponsored'],

      /// image: json['image'] != null ? '${App.baseImgUrl}${json['image']}' : null,
      /// Urls from Cloudinary Cloud Storage
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        // '_id': id,
        'agency': agency?.id,
        'post': post,
        'origin': origin?.id,
        'destination': destination?.id,
        'scheduleDate': scheduleDate?.toIso8601String(),
        'pricePerTraveller': pricePerTraveller,
        'midpoints': midpoints?.map((m) => m.toJson()).toList(),
        // 'createdAt': createdAt?.toIso8601String(),
        // 'seats': seats,
        'description': description,
        'isSponsored': isSponsored,
        'image': image != null ? basename(File(image ?? "").path) : null,
      };

  RouteModel copyWith({
    String? id,
    Agency? agency,
    String? post,
    City? origin,
    City? destination,
    DateTime? scheduleDate,
    double? pricePerTraveller,
    List<RouteMidpoint>? midpoints,
    DateTime? createdAt,
    // List<dynamic>? seats,
    String? description,
    bool? isSponsored,
    String? image,
  }) {
    return RouteModel(
      id: id ?? this.id,
      agency: agency ?? this.agency,
      post: post ?? this.post,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      pricePerTraveller: pricePerTraveller ?? this.pricePerTraveller,
      midpoints: midpoints ?? this.midpoints,
      createdAt: createdAt ?? this.createdAt,
      // seats: seats ?? this.seats,
      description: description ?? this.description,
      isSponsored: isSponsored ?? this.isSponsored,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      agency,
      post,
      origin,
      destination,
      scheduleDate,
      pricePerTraveller,
      midpoints,
      createdAt,
      // seats,
      description,
      isSponsored,
      image
    ];
  }
}

class RouteMidpoint extends Equatable {
  final City? city;
  final DateTime? arrivalTime;
  final DateTime? departureTime;
  final int? order;
  final String? id;
  final String? description;
  final double? price;

  const RouteMidpoint(
      {this.city,
      this.departureTime,
      this.arrivalTime,
      this.order,
      this.id,
      this.price,
      this.description});

  factory RouteMidpoint.fromJson(Map<String, dynamic> json) => RouteMidpoint(
        city: json['city'] == null
            ? null
            : City.fromJson(json['city'] as Map<String, dynamic>),
        arrivalTime: json['arrivalTime'] == null
            ? null
            : DateTime.parse(json['arrivalTime'] as String),
        departureTime: json['departureTime'] == null
            ? null
            : DateTime.parse(json['departureTime'] as String),
        order: json['order'] as int?,
        id: json['_id'] as String?,
        description: json['description'] as String?,
        price: double.tryParse(json['price']?.toString() ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "city": city?.id,
        "arrivalTime": arrivalTime?.toIso8601String(),
        // "departureTime": departureTime?.toIso8601String(),
        // 'order': order,
        // '_id': id,
        "description": description,
        "price": price
      };

  RouteMidpoint copyWith({
    City? city,
    DateTime? arrivalTime,
    DateTime? departureTime,
    int? order,
    String? id,
    double? price,
    String? description,
  }) {
    return RouteMidpoint(
      city: city ?? this.city,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      order: order ?? this.order,
      id: id ?? this.id,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props =>
      [city, departureTime, arrivalTime, order, id, price, description];

  @override
  String toString() {
    return 'Midpoint{city=$city, arrivalTime=$arrivalTime, departureTime=$departureTime, order=$order, id=$id, description=$description, price=$price}';
  }
}
