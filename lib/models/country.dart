class Country {
  Country({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  Country copyWith({
    int? id,
    String? name,
  }) {
    return Country(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  @override
  String toString() {
    return 'Country{id=$id, name=$name}';
  }
}
