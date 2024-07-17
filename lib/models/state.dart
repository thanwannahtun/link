class State {
  State({
    this.id,
    this.name,
    this.countryId,
  });

  final int? id;
  final String? name;
  final int? countryId;

  State copyWith({
    int? id,
    String? name,
    int? countryId,
  }) {
    return State(
      id: id ?? this.id,
      name: name ?? this.name,
      countryId: countryId ?? this.countryId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "countryId": countryId,
    };
  }

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'] as int?,
      name: json['name'] as String?,
      countryId: json['countryId'] as int?,
    );
  }

  @override
  String toString() {
    return 'State{id=$id, name=$name, countryId=$countryId}';
  }
}
