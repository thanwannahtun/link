import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';

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
    bool borderTransparent = false,
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
      constraints: constraints,
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
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerTheme: DividerThemeData(
                        color: borderTransparent ? Colors.transparent : null),
                  ),
                  child: Scaffold(
                    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                    body: SingleChildScrollView(padding: padding, child: body),
                    persistentFooterButtons: persistentFooterButtons,
                  ),
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

  static Future<T?> showAlertDialog<T>(
    BuildContext context, {
    required Widget headerWidget,
    required List<T> itemList,
    required Widget? Function(BuildContext, int) itemBuilder,
  }) async {
    return await showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            // color: Colors.amber,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Expanded(child: headerWidget)],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: context.tertiaryColor.withOpacity(0.7)),
                            bottom: BorderSide(
                                color:
                                    context.tertiaryColor.withOpacity(0.7)))),
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: itemBuilder,
                        physics: const ClampingScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              thickness: 0.2,
                            ),
                        itemCount: itemList.length),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
