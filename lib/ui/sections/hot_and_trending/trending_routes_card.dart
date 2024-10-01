import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

class TrendingRoutesCard extends StatefulWidget {
  const TrendingRoutesCard({super.key});

  @override
  State<TrendingRoutesCard> createState() => _TrendingRoutesCardState();
}

class _TrendingRoutesCardState extends State<TrendingRoutesCard> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: _body(context),
      title: Text(
        "Trending Routes",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      // backButton: BackButton(
      //   onPressed: () => context.pop(),
      // ),
      action: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.filter_alt,
            size: AppInsets.inset30,
            color: context.onPrimaryColor,
          )),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return PostRouteCard(post: Post());
        },
      ),
    );
  }
}
