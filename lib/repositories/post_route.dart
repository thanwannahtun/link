import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/app.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:path/path.dart';

class PostRouteRepo {
  final ApiService _apiService;

  PostRouteRepo({required ApiService apiService}) : _apiService = apiService;

  // ignore: unused_element
  FutureOr<List<Post>> _fetchRoutes(
      {Object? body, Map<String, dynamic>? query}) async {
    Response response =
        await _apiService.postRequest('/routes', body, queryParameters: query);
    if (response.statusCode == 200) {
      List<Post> routes = [];
      for (var route in response.data['data']) {
        routes.add(Post.fromJson(route as Map<String, dynamic>));
      }
      return routes;
    } else {
      throw Exception("Failed to get Routes!");
    }
  }

  FutureOr<Post> uploadNewPost(
      {required Post post, List<File?> files = const []}) async {
    try {
      List<File> compressedFiles =
          await Future.wait(files.whereType<File>().map((file) async {
        return await App.compressImage(file);
      }));

      List<MultipartFile> multipartFiles = [];

      for (var file in compressedFiles) {
        multipartFiles.add(
          await MultipartFile.fromFile(file.path,
              filename: basename(file.path)),
        );
      }
      final data = post.toJson();
      FormData formData = FormData.fromMap(data)
        ..files
            .addAll(multipartFiles.map((f) => MapEntry("files", f)).toList());

      Response response =
          await _apiService.postRequest('/routes/uploads/', formData);
      if (response.statusCode == 201) {
        return Post.fromJson(response.data['data'][0]);
      } else {
        throw Exception("Failed to upload a new post");
      }
    } catch (e, s) {
      debugPrint("error ::::-> $e  , stackTrace :::-> $s");
      rethrow;
    }
  }

  FutureOr<List<RouteModel>> fetchRoutesByCategory(
      {Object? body, Map<String, dynamic>? query}) async {
    Response response = await _apiService.getRequest("/routes",
        body: body, queryParameters: query);
    if (response.statusCode == 200) {
      // print("running on separate Isolate!");
      // final routes = await Isolate.run(
      // () {
      List<RouteModel> routes = [];
      for (var route in response.data['data']) {
        routes.add(RouteModel.fromJson(route as Map<String, dynamic>));
      }
      return routes;
      // },
      // );
      // return routes;
    } else {
      throw Exception("Failed to get Routes!");
    }
  }

  FutureOr<List<Post>> getPostWithRoutes(
      {Object? body, Map<String, dynamic>? query}) async {
    Response response = await _apiService.getRequest("/routes",
        body: body, queryParameters: query);
    if (response.statusCode == 200) {
      List<Post> routes = [];
      for (var route in response.data['data']) {
        routes.add(Post.fromJson(route as Map<String, dynamic>));
      }
      return routes;
    } else {
      throw Exception("Failed to get Routes!");
    }
  }
}

class FileMap {
  final int index;
  final File? file;

  FileMap({required this.index, this.file});
}
