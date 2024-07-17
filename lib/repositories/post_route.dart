import 'dart:async';

import 'package:dio/dio.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/post_route.dart';

class PostRouteRepo {
  static final PostRouteRepo _instance = PostRouteRepo._();
  PostRouteRepo._();
  factory PostRouteRepo() => _instance;

  FutureOr<List<PostRoute>> fetchRoutes() async {
    Response response = await ApiService().getRequest('/routes');
    List<PostRoute> routes = [];
    if (response.statusCode == 200) {
      for (var route in response.data['data']) {
        print("route::: $route");
        routes.add(PostRoute.fromJson(route as Map<String, dynamic>));
      }

      print("routes ::  $routes");
      return routes;
    } else {
      throw Exception("Failed to get Routes!");
    }
  }
}
