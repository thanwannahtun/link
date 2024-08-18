import 'package:equatable/equatable.dart';
import 'package:link/models/city.dart';

class Midpoint extends Equatable {
  final City? city;
  final DateTime? arrivalTime;
  final int? order;
  final String? id;
  final String? description;

  const Midpoint(
      {this.city, this.arrivalTime, this.order, this.id, this.description});

  factory Midpoint.fromJson(Map<String, dynamic> json) => Midpoint(
        city: json['city'] == null
            ? null
            : City.fromJson(json['city'] as Map<String, dynamic>),
        arrivalTime: json['arrivalTime'] == null
            ? null
            : DateTime.parse(json['arrivalTime'] as String),
        order: json['order'] as int?,
        id: json['_id'] as String?,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'city': city?.toJson(),
        'arrivalTime': arrivalTime?.toIso8601String(),
        'order': order,
        '_id': id,
        'description': description,
      };

  Midpoint copyWith({
    City? city,
    DateTime? arrivalTime,
    int? order,
    String? id,
    String? description,
  }) {
    return Midpoint(
      city: city ?? this.city,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      order: order ?? this.order,
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [city, arrivalTime, order, id, description];
}
