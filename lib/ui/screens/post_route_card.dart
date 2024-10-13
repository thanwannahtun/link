import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/core/widgets/cached_image.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/utils/expandable_text.dart';
import 'package:link/ui/widget_extension.dart';

import '../../models/app.dart';
import '../widgets/photo_view_gallery_widget.dart';

// ignore: must_be_immutable
class PostRouteCard extends StatelessWidget {
  PostRouteCard({
    super.key,
    required this.post,
    this.loading = false, // for shimmer purpose
    this.isLike = false,
    this.onAgencyPressed,
    this.onMenuPressed,
    this.onSharePressed,
    this.onStarPressed,
    this.onCommentPressed,
    this.onLocationPressed,
    this.onPhonePressed,
    this.onPhotoPressed,
    this.paddingLeft,
  });

  final Post post;
  bool loading;
  bool isLike;

  /// start
  void Function()? onAgencyPressed;
  void Function()? onMenuPressed;
  void Function()? onSharePressed;
  void Function()? onPhonePressed;
  void Function()? onCommentPressed;
  void Function(bool isLiked)? onStarPressed;
  void Function()? onPhotoPressed;
  void Function()? onLocationPressed;
  EdgeInsetsGeometry? paddingLeft;

  /// end

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1))),
      margin: const EdgeInsets.all(0.0),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppInsets.inset8,
                right: AppInsets.inset8,
                top: AppInsets.inset8,
              ),
              child: _cardHeader(),
            ), // head
            const SizedBox(
              height: 5,
            ),

            /// Title & Description
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppInsets.inset8),
                child: _buildPostTitleDescription()),

            /// Images Section
            _buildImageWidget(post.images),

            /// Images
            // Container(
            //   height: 200,
            //   width: double.infinity,
            //   color: Colors.blueAccent,
            //   child: Image.network(
            //       "https://images.stockcake.com/public/8/4/f/84f518cc-4f5c-4bd4-95fd-7432ac50086d_large/doctors-in-meeting-stockcake.jpg"),
            // ),

            /// Midpoints
            _buildMidpoints(),
            // ),
            const Divider(
              height: 0.3,
              thickness: 0.05,
            ),

            /// for counts
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
            /// Card Footer
            BuildCardFooter(
                    loading: loading,
                    isLike: isLike,
                    onStarPressed: onStarPressed ?? (value) {},
                    onCommentPressed: onCommentPressed,
                    onPhonePressed: onPhonePressed,
                    onLocationPressed: onLocationPressed,
                    onSharePressed: onSharePressed)
                .padding(padding: const EdgeInsets.all(10.0)),
            // icons
            // const Divider(
            //   height: 0.3,
            //   thickness: 0.05,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(List<String>? images) {
    if ((images ?? []).isEmpty) {
      return Container(
        height: loading ? 100 : null,
        color: Colors.black12,
      );
    } else {
      return GestureDetector(
        onTap: onPhotoPressed,
        child: PhotoViewGalleryWidget(
          backgroundDecoration: const BoxDecoration(color: Colors.black12),
          images:
              post.images?.map((img) => '${App.baseImgUrl}$img').toList() ?? [],
        ).sizedBox(height: 200, width: double.infinity),
      );
    }
  }

  Row _cardHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: paddingLeft ?? const EdgeInsets.only(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: loading ? null : onAgencyPressed,
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.black12,
                    child: loading
                        ? null
                        : CachedImage(
                            imageUrl: post.agency?.profileImage ??
                                "https://www.shutterstock.com/image-vector/travel-logo-agency-260nw-2274032709.jpg"),
                  ).clipRRect(
                    borderRadius: BorderRadius.circular(50),
                  ),
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
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    // post.scheduleDate?.toIso8601String() ?? "",
                    DateTimeUtil.formatDateTime(post.scheduleDate),
                    style: const TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ],
              )
            ],
          ),
        ), // profile section
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              child: InkWell(
                  onTap: loading ? null : onMenuPressed,
                  child: const Icon(Icons.more_vert_outlined)),
            ),
          ),
        ), // option section
      ],
    );
  }

  Padding _buildPostTitleDescription() {
    return Padding(
      padding: paddingLeft ?? const EdgeInsets.only(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: loading
            ? [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                  child: Container(
                    height: 15,
                    width: 100,
                    color: Colors.black12,
                  ).clipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                )
              ]
            : [
                Text(
                  post.title ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (post.description != null)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
    );
  }

  SizedBox _buildMidpoints() {
    return SizedBox(
      height: 50,
      width: double.infinity,

      /// temporary
      child: loading
          ? ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  width: 100,
                  height: double.infinity,
                  color: Colors.black12,
                ),
              ).clipRRect(borderRadius: BorderRadius.circular(50)),
            )
          : ListView.builder(
              itemCount: post.midpoints?.length ?? 0,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index < post.midpoints!.length) {
                  TextStyle textStyle =
                      TextStyle(fontSize: 12, color: context.tertiaryColor);
                  if (index == 0 || index == (post.midpoints!.length - 1)) {
                    textStyle = textStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    );
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
                            post.midpoints![index].city?.name ?? "",
                            style: textStyle,
                          )),
                      if (index < post.midpoints!.length - 1)
                        const Icon(
                          Icons.swap_horiz_rounded,
                        ),
                    ],
                  );
                } else {
                  return Container(); // Placeholder, should not be reached
                }
              },
            ),
    );
  }
}

class BuildCardFooter extends StatelessWidget {
  const BuildCardFooter({
    super.key,
    required this.loading,
    required this.onStarPressed,
    required this.onCommentPressed,
    required this.onPhonePressed,
    required this.onLocationPressed,
    required this.onSharePressed,
    required this.isLike,
  });

  final bool loading;
  final bool isLike;
  final void Function(bool isLiked) onStarPressed;
  final void Function()? onCommentPressed;
  final void Function()? onPhonePressed;
  final void Function()? onLocationPressed;
  final void Function()? onSharePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: LikeIcon(
            isLike: isLike,
            toggleLike: onStarPressed,
          ),
          /*
          InkWell(
              onTap: loading ? null : onStarPressed,
              child: const Icon(Icons.hotel_class_outlined)),
              */
        ),
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
    );
  }
}

class LikeIcon extends StatefulWidget {
  const LikeIcon({super.key, this.isLike = false, required this.toggleLike});

  // Initial 'like' state
  final bool isLike;

  // External function that accepts the updated 'like' state
  final void Function(bool isLiked) toggleLike;

  @override
  State<LikeIcon> createState() => _LikeIconState();
}

class _LikeIconState extends State<LikeIcon> {
  late final ValueNotifier<bool> _likeNotifier;

  @override
  void initState() {
    super.initState();
    // Initialize ValueNotifier with the initial like state
    _likeNotifier = ValueNotifier(widget.isLike);
  }

  // Clean up ValueNotifier to avoid memory leaks
  @override
  void dispose() {
    _likeNotifier.dispose();
    super.dispose();
  }

  // Toggle the like state internally and pass the new value to the external callback
  void _toggleLike() {
    _likeNotifier.value = !_likeNotifier.value;
    widget.toggleLike(_likeNotifier.value); // Pass the updated state
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleLike, // Call the internal toggle function
      icon: ValueListenableBuilder<bool>(
        valueListenable: _likeNotifier,
        builder: (context, value, child) {
          return Icon(
            value ? Icons.star_sharp : Icons.star_border_purple500_sharp,
            color: value
                ? Colors.yellow
                : Colors.grey, // Change color based on state
          );
        },
      ),
    );
  }
}
