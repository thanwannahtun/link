import 'package:flutter/material.dart';

class BookButton extends StatelessWidget {
  /// [Button for booking a route]
  const BookButton(
      {super.key, this.onPressed, this.middleWare, this.onMiddleWareFailed});

  /// Call when [middleware] passed true!
  /// if the middlewWare callBack is null ,
  /// [skip] the middleware and go directly to [next] action!

  final VoidCallback? onPressed;

  /// [callBack] for action when [middleware] failed or return false!
  final VoidCallback? onMiddleWareFailed;

  /// [Middleware] for Checking Next Action!
  /// useful for scenario like checking the user is [authenticated or not] .
  /// return [default] to [true]
  final bool Function()? middleWare;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: ButtonStyle(
            minimumSize: const WidgetStatePropertyAll(Size(30, 30)),
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            backgroundColor: const WidgetStatePropertyAll(Colors.blue)),
        onPressed: () {
          if (middleWare?.call() ?? true) {
            onPressed?.call();
          } else {
            onMiddleWareFailed?.call();
          }
        },
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.phone_enabled_sharp, size: 20),
        label: const Text(""));
  }
}
