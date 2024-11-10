import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

class FileUtil {
  static Future<MultipartFile> multipartFileFromFile(File file) async {
    return await MultipartFile.fromFile(file.path,
        filename: basename(file.path));
  }
}
