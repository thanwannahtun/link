import 'package:dio/dio.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/city.dart';

class CityRepo extends ApiService {
  static final CityRepo _instance = CityRepo._();
  CityRepo._();
  factory CityRepo() => _instance;

  Future<List<City>> fetchCities() async {
    Response response = await getRequest(
      '/cities',
    );

    List<City> cities = [];
    if (response.statusCode != 200) {
      throw Exception("Cities fetch failed");
    }
    for (var city in response.data) {
      cities.add(City.fromJson(city));
    }

    return cities;
  }
}
