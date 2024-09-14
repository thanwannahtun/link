import 'dart:io';

import 'package:link/models/city.dart';
import 'package:link/models/user.dart';
import 'package:image/image.dart' as img;

class App {
  static const baseImgUrl = 'http://192.168.99.217:3000';
  static User user = User();

  static List<City> cities = [];

  /// compressed only over 500 KB of file sizes
  ///
  static Future<File> compressAndResizeImageAdvance(File file) async {
    const int desiredMaxSize = 500 * 1024; // 500 KB in bytes
    final originalFileSize = await file.length();

    // Skip compression if the file is already smaller than the desired size
    if (originalFileSize <= desiredMaxSize) {
      return file; // No need to compress, return original file
    }

    img.Image image = img.decodeImage(await file.readAsBytes())!;

    // Target resolution for resizing
    const int maxResolution = 1280;

    // Calculate new dimensions while maintaining aspect ratio
    int width, height;
    if (image.width > image.height) {
      width = maxResolution;
      height = (image.height / image.width * maxResolution).round();
    } else {
      height = maxResolution;
      width = (image.width / image.height * maxResolution).round();
    }

    // Resize the image
    img.Image resizedImage =
        img.copyResize(image, width: width, height: height);

    // Adjust quality based on original file size
    int quality = 85;
    if (originalFileSize > 5 * 1024 * 1024) {
      // > 5MB
      quality = 70;
    } else if (originalFileSize > 2 * 1024 * 1024) {
      // > 2MB
      quality = 75;
    }

    // Compress the image to JPEG format with the chosen quality
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: quality);

    // Save the compressed image to a new file
    File compressedFile = File(file.path.replaceFirst(
        '.jpg', '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg'));
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  ///
}
