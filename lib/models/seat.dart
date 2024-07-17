enum SeatStatus { available, booked }

class Seat {
  Seat({
    this.routeId,
    this.name,
    this.status,
  });

  final int? routeId;
  final String? name;
  final SeatStatus? status;

  Seat copyWith({
    int? routeId,
    String? name,
    SeatStatus? status,
  }) {
    return Seat(
      routeId: routeId ?? this.routeId,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "routeId": routeId,
      "name": name,
      "status": status?.name,
    };
  }

  factory Seat.fromJson(Map<String, dynamic> json) {
    print("seat::::: ${json['number'].runtimeType} : ${json['number']} ");
    dynamic status = json['status']?.toString().toLowerCase();
    print("seat :: $json");
    return Seat(
      routeId: json['routeId'] as int?,
      name: json['number'] as String?,
      // status: json['status'] != null ? SeatStatus.values[status] : null,
      status: json['status'] != null
          ? SeatStatus.values.firstWhere(
              (e) => e.toString().split('.').last.toLowerCase() == status)
          : null,
    );
  }

  @override
  String toString() {
    return 'Seat{routeId=$routeId, name=$name, status=$status}';
  }
}
