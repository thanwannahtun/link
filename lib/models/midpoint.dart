class MidPoint {
  MidPoint({
    this.cityId,
    this.cityName,
    this.cityOrder,
  });

  final int? cityId;
  final int? cityOrder;
  final String? cityName;

  Map<String, dynamic> toJson() {
    return {
      "cityId": cityId,
      "cityName": cityName,
      "cityOrder": cityOrder,
    };
  }

  factory MidPoint.fromJson(Map<String, dynamic> json) {
    return MidPoint(
      cityId: json['cityId'] as int?,
      cityOrder: json['cityOrder'] as int?,
      cityName: json['cityName'] as String?,
    );
  }

  @override
  String toString() {
    return 'MidPoint{cityId=$cityId, cityOrder=$cityOrder, cityName=$cityName}';
  }
}
