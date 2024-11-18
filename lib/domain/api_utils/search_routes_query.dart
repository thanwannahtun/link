import '../../models/city.dart';

//
// "origin": _originNotifier.value,
// "destination": _destinationNotifier.value,
// "date": _selectedDateNotifier.value
//

class SearchRoutesQuery {
  final City? origin;
  final City? destination;
  final DateTime? date;

  SearchRoutesQuery({
    this.origin,
    this.destination,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        "origin": origin?.id,
        "destination": destination?.id,
        "date": date?.toIso8601String()
      };

  factory SearchRoutesQuery.fromJson(Map<String, dynamic> json) =>
      SearchRoutesQuery(
          origin: json["origin"],
          destination: json["destination"],
          date: json["date"]);

  SearchRoutesQuery copyWith({
    City? origin,
    City? destination,
    DateTime? date,
  }) {
    return SearchRoutesQuery(
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        date: date ?? this.date);
  }
}
