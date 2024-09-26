import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

class SearchQueryRoutes extends StatefulWidget {
  const SearchQueryRoutes({super.key});

  @override
  State<SearchQueryRoutes> createState() => _SearchQueryRoutesState();
}

class _SearchQueryRoutesState extends State<SearchQueryRoutes> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: Container(),
      title: "ReSulTS",
      action: Row(
        children: [
          IconButton.filled(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    context.tertiaryColor.withOpacity(0.8)),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.search_rounded,
                color: context.onPrimaryColor,
              ))
        ],
      ),
    );
  }
}
