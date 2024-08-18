import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Context {
  static showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget body,
    List<Widget>? persistentFooterButtons,
    // required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool useSafeArea = false,
    bool resizeToAvoidBottomInset = false,
    EdgeInsetsGeometry? padding,

    /// [viewInset] for device keyboard height default to false
    bool setViewInset = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    AnimationStyle? sheetAnimationStyle,
  }) async {
    return showModalBottomSheet(
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      useSafeArea: useSafeArea,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      sheetAnimationStyle: sheetAnimationStyle ??
          AnimationStyle(
              curve: Curves.decelerate,
              duration: Durations.long3,
              reverseCurve: Curves.easeInBack,
              reverseDuration: Durations.long2),
      context: context,
      builder: (context) {
        return setViewInset
            ? Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Adjust for the keyboard
                ),
                child: Scaffold(
                  resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                  body: SingleChildScrollView(padding: padding, child: body),
                  persistentFooterButtons: persistentFooterButtons,
                ),
              )
            : Scaffold(
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                body: SingleChildScrollView(padding: padding, child: body),
                persistentFooterButtons: persistentFooterButtons,
              );
      },
    );
  }
}
