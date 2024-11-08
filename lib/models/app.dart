import 'dart:io';
import 'dart:isolate';

import 'package:link/models/city.dart';
import 'package:link/models/user.dart';

import '../domain/utils/image_compress.dart';

class App {
  // static const baseImgUrl = 'http://192.168.99.217:3000';
  static const baseImgUrl = 'http://localhost:3000';

  /// Render Url
  // static const baseImgUrl = 'https://link-myanmar-mongodb.onrender.com';
  static User user = User();

  static List<City> cities = [];

  /// compressed only over 500 KB of file sizes
  ///
  static Future<File> compressImage(File file) async {
    /// compute() & Isolate.run() functions run in parallel to the main threads
    // ignore: avoid_print
    // return await compute(ImageCompress.compressImageSync, file.path);
    return Isolate.run(() => ImageCompress.compressImageSync(file.path));
  }

  ///
  static List<String> currencies = ["Ks", "EU", "Pound", "Dollar"];
}
