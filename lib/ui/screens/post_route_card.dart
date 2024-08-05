import 'package:flutter/material.dart';
import 'package:link/models/post_route.dart';
import 'package:link/ui/utils/expandable_text.dart';
import 'package:link/ui/widget_extension.dart';

class PostRouteCard extends StatelessWidget {
  PostRouteCard({
    super.key,
    required this.post,
    this.loading = false, // for shimmer purpose
    this.onAgencyPressed,
    this.onMenuPressed,
    this.onSharePressed,
    this.onStarPressed,
    this.onCommentPressed,
    this.onLocationPressed,
    this.onPhonePressed,
  });

  final PostRoute post;
  bool loading;

  /// start
  void Function()? onAgencyPressed;
  void Function()? onMenuPressed;
  void Function()? onSharePressed;
  void Function()? onPhonePressed;
  void Function()? onCommentPressed;
  void Function()? onStarPressed;
  void Function()? onLocationPressed;

  /// end

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: loading ? null : onAgencyPressed,
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.black38,
                        child: loading
                            ? null
                            : Image.network(
                                post.agency?.logo ?? "",
                                fit: BoxFit.cover,
                              ),
                      ).clipRRect(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (loading)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white24,
                            height: 15,
                            width: 70,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            color: Colors.white24,
                            height: 10,
                            width: 130,
                          ),
                        ],
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: loading ? null : onAgencyPressed,
                          child: Text(post.agency?.name ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Text(
                          post.scheduleDate?.toIso8601String() ?? "",
                          style:
                              const TextStyle(fontSize: 10, color: Colors.red),
                        ),
                      ],
                    )
                  ],
                ).sizedBox(),
              ), // profile section
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      child: InkWell(
                          onTap: loading ? null : onMenuPressed,
                          child: const Icon(Icons.more_vert_outlined)),
                    ),
                  )), // option section
            ],
          ), // head
          const SizedBox(
            height: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                post.title ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (post.description != null)
                Column(children: [
                  SizedBox.fromSize(
                    size: const Size.fromHeight(10),
                  ),
                  ExpandableText(
                    text: post.description ?? "",
                  ),
                  SizedBox.fromSize(
                    size: const Size.fromHeight(10),
                  ),
                ]),
            ],
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blueAccent,
            child: Image.network(
                "https://images.stockcake.com/public/8/4/f/84f518cc-4f5c-4bd4-95fd-7432ac50086d_large/doctors-in-meeting-stockcake.jpg"),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,

            /// temporary
            child: loading
                ? ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        width: 100,
                        height: double.infinity,
                        color: Colors.black38,
                      ),
                    ).clipRRect(borderRadius: BorderRadius.circular(50)),
                  )
                : ListView.builder(
                    itemCount: post.midpoints?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index < post.midpoints!.length) {
                        TextStyle textStyle = const TextStyle(
                            fontSize: 12, color: Colors.black54);
                        if (index == 0 ||
                            index == (post.midpoints!.length - 1)) {
                          textStyle = textStyle.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black);
                        }
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (loading) {
                                    return;
                                  }
                                },
                                child: Text(
                                  post.midpoints![index].cityName ?? "",
                                  style: textStyle,
                                )),
                            if (index < post.midpoints!.length - 1)
                              const Text(
                                  ' -> '), // Add separator if not the last item
                          ],
                        );
                      } else {
                        return Container(); // Placeholder, should not be reached
                      }
                    },
                  ),
          ),
          // ),
          const Divider(
            height: 0.3,
          ),

          //// for counts
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Expanded(child: Text((post.likeCounts ?? 0).toString())),
          //     Expanded(child: Text((post.commentCounts ?? 0).toString())),
          //     Expanded(child: Text((post.commentCounts ?? 0).toString())),
          //   ],
          // ),
          // image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: InkWell(
                      onTap: loading ? null : onStarPressed,
                      child: const Icon(Icons.hotel_class_outlined))),
              Expanded(
                  child: InkWell(
                      onTap: loading ? null : onCommentPressed,
                      child: const Icon(Icons.comment))),
              Expanded(
                  child: InkWell(
                      onTap: loading ? null : onPhonePressed,
                      child: const Icon(Icons.phone))),
              Expanded(
                child: InkWell(
                    onTap: loading ? null : onLocationPressed,
                    child: const Icon(Icons.location_on_outlined)),
              ),
              Expanded(
                child: InkWell(
                    onTap: loading ? null : onSharePressed,
                    child: const Icon(Icons.share)),
              ),
            ],
          ).padding(padding: const EdgeInsets.all(10.0)),
          // icons
          const Divider(
            height: 0.3,
          ),
        ],
      ),
    );
  }
}