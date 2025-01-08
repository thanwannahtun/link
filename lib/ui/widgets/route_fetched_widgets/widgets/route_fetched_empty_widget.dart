import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/ui/widget_extension.dart';

class RouteFetchedEmptyWidget extends StatelessWidget {
  const RouteFetchedEmptyWidget({super.key, this.onActionPressed});

  /// [callBack] actions like
  ///
  /// [refresh] callback ,
  /// [navigating] to new route callback
  ///
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          color: context.tertiaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "There is no data currently",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).fittedBox(),
              const SizedBox(height: AppInsets.inset15),
              ElevatedButton(
                  onPressed: onActionPressed,
                  child: const Text("Start Creating A Post"))
            ],
          ).padding(padding: const EdgeInsets.all(AppInsets.inset8)),
        ).expanded(),
      ],
    );
  }
}
