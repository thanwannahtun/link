class City {
  City({
    this.id,
    this.name,
    this.stateId,
  });

  final String? id;
  final String? name;
  final String? stateId;

  City copyWith({
    String? id,
    String? name,
    String? stateId,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      stateId: stateId ?? this.stateId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "country_id": stateId, // ! tempory
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'],
      name: json['name'],
      stateId: json['country_id'], // ! tempory
    );
  }

  @override
  String toString() {
    return 'City{_id=$id, name=$name, country_id=$stateId}'; // ! tempory
  }
}
