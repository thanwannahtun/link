import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/ui/widget_extension.dart';

class RouteFetchedFailWidget extends StatelessWidget {
  const RouteFetchedFailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          color: context.greyFilled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Something went wrong!\n"
                "Please check your Network Connection 🛜",
                // context.read<ConnectivityBloc>().state.status.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: context.greyColor),
                textAlign: TextAlign.center,
              ).fittedBox(),
            ],
          ).padding(padding: const EdgeInsets.all(AppInsets.inset20)),
        ).expanded(),
      ],
    );
  }
}
