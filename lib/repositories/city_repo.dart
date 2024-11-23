import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link/core/utils/hive_box_name.dart';
import 'package:link/data/hive/hive_util.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/city.dart';

class CityRepo extends ApiService {
  static final CityRepo _instance = CityRepo._();
  CityRepo._();
  factory CityRepo() => _instance;
  final hiveUtil = HiveUtil();
  Future<List<City>> fetchCities() async {
    final cities = await hiveUtil.getAllValues<City>(HiveBoxName.cities);
    if (cities.isNotEmpty) {
      return cities;
    } else {
      return _fetchCities();
    }
  }

  Future<List<City>> _fetchCities() async {
    try {
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
      await _storeCities(cities);
      return cities;
    } on Exception catch (e) {
      debugPrint("[Exception] ::: $e");
      return [];
    }
  }

  Future<void> _storeCities(List<City> cities) async {
    await hiveUtil.clearAllValues<City>(
        boxName: HiveBoxName.cities); // Clear existing data
    for (var city in cities) {
      await hiveUtil.addValue(HiveBoxName.cities, city, city.id);
    }
  }
}

/*
class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}

Future<Result<List<City>>> _fetchCities() async {
  try {
    Response response = await getRequest('/cities');

    if (response.statusCode != 200) {
      throw Exception("Cities fetch failed");
    }

    List<City> cities = [];
    for (var city in response.data) {
      cities.add(City.fromJson(city));
    }

    return Result.success(cities);
  } catch (e) {
   Handle error here (e.g., log it, show an error message)
    print('Error fetching cities: $e');
    Return failure result with error message
    return Result.failure(e.toString());
  }
}

 */
