import 'package:flutter/material.dart';

enum SeatStatus { available, booked }

class Seat {
  Seat({
    this.id,
    this.number,
    this.status,
    this.type,
  });

  final String? id;
  final String? number;
  final String? type;
  final SeatStatus? status;

  Seat copyWith({
    String? id,
    String? number,
    SeatStatus? status,
    String? type,
  }) {
    return Seat(
      id: id ?? this.id,
      number: number ?? this.number,
      type:type ?? this.type,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "number": number,
      "type":type,
      "status": status?.name,
    };
  }

  factory Seat.fromJson(Map<String, dynamic> json) {
    dynamic status = json['status']?.toString().toLowerCase();
    return Seat(
      id: json['_id'],
      number: json['number'],
        type: json['type'] as String?,

      // status: json['status'] != null ? SeatStatus.values[status] : null,
      status: json['status'] != null
          ? SeatStatus.values.firstWhere(
              (e) => e.toString().split('.').last.toLowerCase() == status)
          : null,
    );
  }

  @override
  String toString() {
    return 'Seat{_id=$id, number=$number, type=$type, status=$status}';
  }
}
