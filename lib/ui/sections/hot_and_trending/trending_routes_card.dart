import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post/upload_new_post_page.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../models/app.dart';

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
      backButton: BackButton(
        onPressed: () => context.pop(),
      ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5),
          child: SizedBox(
            height: 50,
            // color: Colors.amber,
            child: _buildFilters(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5),
            child: _postViewBuilder(),
          ),
        ),
      ],
    );
  }

  ListView _postViewBuilder() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppInsets.inset5),
          child: PostRouteCard(post: Post()),
        );
      },
    );
  }

  ListView _buildFilters() {
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final city = App.cities[index];
        return Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Chip(
            label: Text(city.name ?? ""),
            deleteIcon: const Icon(Icons.arrow_drop_down),
            side: BorderSide.none,
            onDeleted: () => showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                color: Colors.blue[50],
              ),
            ),
            deleteButtonTooltipMessage: "Filter",
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 5,
      ),
      itemCount: App.cities.length,
    );
  }
}
