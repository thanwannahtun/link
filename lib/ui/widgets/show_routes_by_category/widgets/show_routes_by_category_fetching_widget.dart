import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:shimmer/shimmer.dart';

class ShowRoutesByCategoryFetchingWidget extends StatelessWidget {
  const ShowRoutesByCategoryFetchingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Shimmer.fromColors(
                  baseColor: context.primaryColor,
                  highlightColor: context.onPrimaryColor,
                  child: const Chip(
                    label: Text(" suggestion "),
                    deleteIcon: Icon(Icons.search),
                  ),
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: 10,
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: context.primaryColor,
                highlightColor: context.onPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PostRouteCard(
                    post: const Post(),
                    loading: true,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
