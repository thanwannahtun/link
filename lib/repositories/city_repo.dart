import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link/core/utils/hive_box_name.dart';
import 'package:link/data/hive/hive_util.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/city.dart';

// class CityRepo extends ApiService {
class CityRepo {
  // static final CityRepo _instance = CityRepo._();
  // CityRepo._();
  // factory CityRepo() => _instance;

  late final HiveUtil _hiveUtil;
  late final ApiService _apiService;

  CityRepo({
    required HiveUtil hiveUtil,
    required ApiService apiservice,
  }) {
    _hiveUtil = hiveUtil;
    _apiService = apiservice;
  }

  Future<List<City>> fetchCities() async {
    final cities = await _hiveUtil.getAllValues<City>(HiveBoxName.cities);
    if (cities.isNotEmpty) {
      return cities;
    } else {
      return _fetchCities();
    }
  }

  Future<List<City>> _fetchCities() async {
    try {
      Response response = await _apiService.getRequest(
        '/cities',
      );

      List<City> cities = [];
      if (response.statusCode != 200) {
        throw Exception("Cities fetch failed");
      }
      for (var city in response.data) {
        print('city => ${city}');
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
    await _hiveUtil.clearAllValues<City>(
        boxName: HiveBoxName.cities); // Clear existing data
    for (var city in cities) {
      await _hiveUtil.addValue<City>(HiveBoxName.cities, city, city.id);
    }
  }
}
