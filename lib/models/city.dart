class City {
  City({
    this.id,
    this.name,
    this.stateId,
  });

  final int? id;
  final String? name;
  final int? stateId;

  City copyWith({
    int? id,
    String? name,
    int? stateId,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      stateId: stateId ?? this.stateId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "stateId": stateId,
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] as String?,
      stateId: json['stateId'],
    );
  }

  @override
  String toString() {
    return 'City{id=$id, name=$name, stateId=$stateId}';
  }
}
