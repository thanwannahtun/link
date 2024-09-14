import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/app.dart';
import 'package:link/models/post.dart';
import 'package:path/path.dart';

class PostRouteRepo extends ApiService {
  static final PostRouteRepo _instance = PostRouteRepo._();

  PostRouteRepo._();
  factory PostRouteRepo() => _instance;

  FutureOr<List<Post>> fetchRoutes() async {
    Response response = await getRequest('/routes');
    List<Post> routes = [];
    if (response.statusCode == 200) {
      for (var route in response.data['data']) {
        routes.add(Post.fromJson(route as Map<String, dynamic>));
      }

      return routes;
    } else {
      throw Exception("Failed to get Routes!");
    }
  }

/*

{
  "agency": "66b8d28d3e1a9b47a2c0e69c",
  "origin": "66b613cd6c17b0be8b372dc7",
  "destination": "66b613cd6c17b0be8b372dce",
  "scheduleDate": "2024-09-01T09:00:00.000Z",
  "pricePerTraveler": 38000,
  "seats": [
    {"number": "1", "type": "Economy"},
    {"number": "2", "type": "Economy"},
    {"number": "3", "type": "Economy"},
     {"number": "4", "type": "Economy"},
    {"number": "5", "type": "Economy"},
    {"number": "6", "type": "Business"},
     {"number": "7", "type": "Business","status":"booked"}
  ],
  "midpoints": [
    {"city": "66b613cd6c17b0be8b372dcf", "arrivalTime": "2024-09-01T12:00:00.000Z"},
    {"city": "66b613cd6c17b0be8b372dc8", "arrivalTime": "2024-09-01T15:00:00.000Z","order":1},
    {"city": "66b613cd6c17b0be8b372dcd", "arrivalTime": "2024-09-02T12:00:00.000Z","order":1},
    {"city": "66b613cd6c17b0be8b372dc7", "arrivalTime": "2024-09-03T15:00:00.000Z","order":2}
    
  ],
  "title": "Travel around the world with us!",
  "description": "Happy Travelling!😎😎."
}

 */
  FutureOr<Post> uploadNewPost(
      {required Post post, List<File?> files = const []}) async {
    try {
      debugPrint("files___ : $files");
      List<File> compressedFiles = [];
      for (var file in files) {
        if (file != null) {
          compressedFiles.add(await App.compressAndResizeImageAdvance(file));
        }
      }

      List<MultipartFile> multipartFiles = [];

      for (var file in compressedFiles) {
        multipartFiles.add(
          await MultipartFile.fromFile(file.path,
              filename: basename(file.path)),
        );
      }
      final data = post.toJson();
      FormData formData = FormData.fromMap(data);
      formData.files
          .addAll(multipartFiles.map((f) => MapEntry("files", f)).toList());
      debugPrint(
          "formData :::::::::: ${formData.files.map((f) => f.value.filename)} ::::: |||||||||");
      Response response = await postRequest('/routes', formData);
      if (response.statusCode == 201) {
        return Post.fromJson(response.data['data'].first);
      } else {
        throw Exception("Failed to upload a new post");
      }
    } catch (e, s) {
      debugPrint("error ::::-> $e  , stackTrace :::-> $s");
      rethrow;
    }
  }
}
