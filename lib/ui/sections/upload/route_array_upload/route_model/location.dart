import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double? lat;
  final double? lon;

  const Location({this.lat, this.lon});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: (json['lat'] as num?)?.toDouble(),
        lon: (json['lon'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
      };

  Location copyWith({
    double? lat,
    double? lon,
  }) {
    return Location(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  @override
  List<Object?> get props => [lat, lon];
}
