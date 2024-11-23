// ignore_for_file: unused_element

import 'package:equatable/equatable.dart';
import 'package:link/models/city.dart';

class Midpoint extends Equatable {
  String? description;
  String? arrivalTime;
  int? price;
  City? city;

  Midpoint({
    this.city,
    this.price,
    this.description,
    this.arrivalTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [description, arrivalTime, price, city];
}

/// Upload New Post logic
///
/*
import 'package:dio/dio.dart';

Future<void> uploadRoute(RouteModel route) async {
  Dio dio = Dio();

  FormData formData = FormData.fromMap({
    "origin": route.origin,
    "destination": route.destination,
    "scheduleDate": route.scheduleDate.toIso8601String(),
    "pricePerTraveller": route.pricePerTraveller,
    "midpoints": route.midpoints.map((m) => m.toJson()).toList(),
    if (route.routeImagePath != null)
      "routeImage": await MultipartFile.fromFile(route.routeImagePath!),
  });

  Response response = await dio.post(
    'https://your-api-url.com/upload-route',
    data: formData,
  );

  if (response.statusCode == 200) {
    // Handle success
  } else {
    // Handle error
  }
}

*/
