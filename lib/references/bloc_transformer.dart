/*
Flutter BLoC: Transformers ( medium )

https://medium.com/mindful-engineering/flutter-bloc-transformers-7b62c32d80f6


custom transformer

EventTransformer<E> debounceSequential<E>(Duration duration) {
  return (events, mapper) {
    return sequential<E>().call(events.debounceTime(duration), mapper);
  };
}
 */

/*


file:///C:/Users/asus/Downloads/Concurrency%20and%20isolates%20_%20Flutter.mhtml
https://docs.flutter.dev/perf/isolates

Produces a list of 211,640 photo objects.
(The JSON file is ~20MB.)

Future<List<Photo>> getPhotos() async {
  final String jsonString = await rootBundle.loadString('assets/photos.json');
  final List<Photo> photos = await Isolate.run<List<Photo>>(() {
    final List<Object?> photoData = jsonDecode(jsonString) as List<Object?>;
    return photoData.cast<Map<String, Object?>>().map(Photo.fromJson).toList();
  });
  return photos;
}
 */
