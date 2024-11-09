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
    required this.origin,
    required this.destination,
    required this.date,
  });

  Map<String, dynamic> toJson() =>
      {"origin": origin?.id, "destination": destination?.id, "date": date};

  factory SearchRoutesQuery.fromJson(Map<String, dynamic> json) =>
      SearchRoutesQuery(
          origin: json["origin"],
          destination: json["destination"],
          date: json["date"]);
}
