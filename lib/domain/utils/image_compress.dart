import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class ImageCompress {
  static File compressImageSync(String path) {
    debugPrint(
        "-----------------------running in a new Isolate!---------$path");

    File file = File(path);

    const int desiredMaxSize = 500 * 1024; // 500 KB in bytes
    final originalFileSize = file.lengthSync();

    // Skip compression if the file is already smaller than the desired size
    if (originalFileSize <= desiredMaxSize) {
      return file; // No need to compress, return original file
    }

    img.Image image = img.decodeImage(file.readAsBytesSync())!;

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
    compressedFile.writeAsBytesSync(compressedBytes);

    return compressedFile;
  }

  /// Don't use this [ just for reference ]
  // ignore: unused_element
  static Future<File> _compressImageAsync(File file) async {
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
}

/*

import 'dart:async';
import 'dart:isolate';

// The function that will run in the separate isolate
void photoProcessor(SendPort sendPort) {
  // Simulate a long-running task (e.g., processing a photo)
  final processedData = 'Processed Photo Data';

  // Send the result back to the main isolate
  sendPort.send(processedData);
}

Future<void> processPhoto() async {
  // Create a ReceivePort to get data from the isolate
  final receivePort = ReceivePort();

  // Spawn a new isolate
  await Isolate.spawn(photoProcessor, receivePort.sendPort);

  // Listen for data from the isolate
  final result = await receivePort.first;
  print('Photo processing result: $result');
}

*/
/*
import 'dart:isolate';
import 'package:http/http.dart' as http;

// Function running in an isolate
void fetchLargeData(SendPort sendPort) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  sendPort.send(response.body);
}

Future<void> fetchNetworkData() async {
  final receivePort = ReceivePort();

  await Isolate.spawn(fetchLargeData, receivePort.sendPort);

  final data = await receivePort.first;
  print('Received network data: $data');
}

 */

/*
Key Points to Remember:
- Communication between isolates is done via SendPort and ReceivePort.
- Isolates cannot share memory, which avoids concurrency issues but requires explicit data transfer between isolates.
- Isolates are useful for CPU-bound operations, such as data processing or file I/O, while async/await is typically sufficient for IO-bound tasks like network requests.
 */