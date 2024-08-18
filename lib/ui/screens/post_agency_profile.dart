import 'package:flutter/material.dart';
import 'package:link/core/utils/app_date_util.dart';
import 'package:link/models/comment.dart';
import 'package:link/models/post.dart';
import 'package:link/models/seat.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/photo_view_gallery_widget.dart';

class AgencyProfile extends StatefulWidget {
  const AgencyProfile({super.key});

  @override
  State<AgencyProfile> createState() => _AgencyProfileState();
}

class _AgencyProfileState extends State<AgencyProfile> {
  Post? post;

  bool _initial = true;

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        post = ModalRoute.of(context)?.settings.arguments as Post;
        _initial = false;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post?.agency?.name ?? "Agency Profile",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      // primary: true,
      persistentFooterButtons: [
        CommentShareContactFooterButtons(
          post: post,
        )
      ],
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

                    /// PhotoViewGalleryWidget
                    (post?.images ?? []).isEmpty
                        ? Container()
                        : PhotoViewZoomableWidget(post: post),
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
                      AppDateUtil.formatDateTime(post?.scheduleDate),
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
                    SeatsGrid(seats: post?.seats ?? [])
                        .padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        )
                        .padding(
                            padding: const EdgeInsets.symmetric(vertical: 10)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${post?.commentCounts ?? 0} comments",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    BuildReviewWidget(post: post)
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

class PhotoViewZoomableWidget extends StatelessWidget {
  const PhotoViewZoomableWidget({
    super.key,
    required this.post,
  });

  final Post? post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PhotoViewGalleryWidget(
          backgroundDecoration: const BoxDecoration(color: Colors.black45),
          images: post?.images ?? [],
        ),
      )),
      child: SizedBox(
        height: 350,
        width: double.infinity,
        child: PhotoViewGalleryWidget(
            backgroundDecoration: const BoxDecoration(color: Colors.black12),
            images: post?.images ?? []),
      ),
    );
  }
}

class BuildReviewWidget extends StatelessWidget {
  const BuildReviewWidget({
    super.key,
    required this.post,
  });

  final Post? post;

  @override
  Widget build(BuildContext context) {
    return (post?.comments ?? []).isEmpty
        ? const SizedBox(
            height: 100,
            child: Text("Be the first comment!"),
          ).padding(padding: const EdgeInsets.all(15))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: post?.comments?.length,
            itemBuilder: (context, index) {
              List<Comment> comments = post?.comments ?? [];

              Comment comment = comments[index];

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(comment.content ?? ""),
                subtitle: Text(comment.user?.email ?? "user@gmail.com"),
                trailing: Text(comment.createdAt != null
                    ? AppDateUtil.formatDateTime(comment.createdAt)
                    : ""),
              );
            },
          );
  }
}

class CommentShareContactFooterButtons extends StatelessWidget {
  const CommentShareContactFooterButtons({
    super.key,
    required this.post,
  });

  final Post? post;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          tooltip: "comment",
          onPressed: () => onCommentPressed(context),
          icon: const Icon(Icons.comment),
        ).expanded(),
        IconButton(
          tooltip: "share",
          onPressed: () {},
          icon: const Icon(Icons.share),
        ).expanded(),
        IconButton(
          tooltip: "contact us",
          onPressed: () {},
          icon: const Icon(Icons.phone),
        ).expanded(),
      ],
    );
  }

  // ? : onCommentPressed
  void Function()? onCommentPressed(BuildContext context) {
    List<Comment> comments = post?.comments ?? [];

    Context.showBottomSheet(context,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                Comment comment = comments[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(comment.content ?? ""),
                  subtitle: Text(comment.user?.email ?? "user@gmail.com"),
                  trailing: Text(comment.createdAt != null
                      ? AppDateUtil.formatDateTime(comment.createdAt)
                      : ""),
                );
              },
            ),
          ],
        ),
        persistentFooterButtons: [
          _commentFooterButton(context),
        ],
        // useSafeArea: true,
        padding: const EdgeInsets.all(0.0),
        isScrollControlled: true,
        setViewInset: true);
    return null;
  }

  Row _commentFooterButton(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ExampleRoute();
                },
              )).then((v) => {});
            },
            icon: const Icon(Icons.image)),
        const Flexible(
          // Use Flexible instead of Expanded
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.subdirectory_arrow_left_rounded),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              filled: true,
              fillColor: Colors.black12,
              hintText: "Leave a comment...",
            ),
          ),
        )
      ],
    );
  }

//   Row _commentFooterButton() {
//     return Row(
//       children: [
//         IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.image)),
//         const Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               suffixIcon: Icon(Icons.subdirectory_arrow_left_rounded),
//               border: OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                   borderRadius: BorderRadius.all(Radius.circular(12))),
//               filled: true,
//               fillColor: Colors.black12,
//               hintText: "Leave a comment...",
//             ),
//           ),
//         )
//       ],
//     );
//   }
}

/// SeatsGrid widget

class ExampleRoute extends StatelessWidget {
  const ExampleRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class SeatsGrid extends StatelessWidget {
  final List<Seat> seats;

  const SeatsGrid({super.key, required this.seats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: seats.length,
      physics: const NeverScrollableScrollPhysics(),
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
            seat.number ?? "",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
