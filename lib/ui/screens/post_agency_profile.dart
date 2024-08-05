import 'package:flutter/material.dart';
import 'package:link/models/post_route.dart';
import 'package:link/models/seat.dart';
import 'package:link/ui/widget_extension.dart';

class AgencyProfile extends StatefulWidget {
  const AgencyProfile({super.key});

  @override
  State<AgencyProfile> createState() => _AgencyProfileState();
}

class _AgencyProfileState extends State<AgencyProfile> {
  PostRoute? post;

  bool _initial = true;
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Unknown";

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day-$month-$year $hour:$minute $amPm';
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        post = ModalRoute.of(context)?.settings.arguments as PostRoute;
        _initial = false;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.arguments);
    print(post?.agency?.name);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post?.agency?.name ?? "Agency Profile",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: post == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post?.title ?? "",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post?.description ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Image.network(post?.agency?.logo ?? ""),
                    const SizedBox(height: 15),
                    _buildInfoSection(
                      "From",
                      post?.origin?.name ?? "Unknown",
                    ),
                    const SizedBox(height: 5),
                    _buildInfoSection(
                      "To",
                      post?.destination?.name ?? "Unknown",
                    ),
                    const SizedBox(height: 5),
                    _buildInfoSection(
                      "Schedule Date",
                      _formatDateTime(post?.scheduleDate),
                      // post?.scheduleDate?.toIso8601String() ?? "Unknown",
                    ),
                    const SizedBox(height: 5),
                    _buildInfoSection(
                      "Price per Traveler",
                      post?.pricePerTraveler != null
                          ? "\$${post!.pricePerTraveler}"
                          : "Unknown",
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Seats Available:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SeatsGrid(seats: post?.seats ?? []).padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "$label: ",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SeatsGrid widget

class SeatsGrid extends StatelessWidget {
  final List<Seat> seats;

  const SeatsGrid({super.key, required this.seats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: seats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return SeatWidget(seat: seats[index]);
      },
    );
  }
}

/// SeatWidget widget

class SeatWidget extends StatelessWidget {
  final Seat seat;

  const SeatWidget({super.key, required this.seat});

  @override
  Widget build(BuildContext context) {
    Color seatColor;
    switch (seat.status) {
      case SeatStatus.available:
        seatColor = Colors.green;
        break;
      // case SeatStatus.booked:
      //   seatColor = Colors.orange;
      //   break;
      case SeatStatus.booked:
        seatColor = Colors.red;
        break;
      default:
        seatColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        // Handle seat tap, e.g., show more info or select seat
      },
      child: Container(
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            seat.name ?? "",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
