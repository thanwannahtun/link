import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomScaffoldBody extends StatelessWidget {
  CustomScaffoldBody(
      {super.key,
      required this.body,
      required this.title,
      this.backButton,
      this.resizeToAvoidBottomInset,
      this.action,
      this.floatingActionButton,
      this.persistentFooterButtons});

  final Widget body;
  final Widget title;
  Widget? action;
  bool? resizeToAvoidBottomInset;
  Widget? backButton;
  Widget? floatingActionButton;
  List<Widget>? persistentFooterButtons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      persistentFooterButtons: persistentFooterButtons,
      appBar: _appBar(context),
      body: _body(context),
      floatingActionButton:floatingActionButton,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      title: title,
      leadingWidth: backButton != null ? 56 : 0.0,
      // 56 == default
      automaticallyImplyLeading: true,
      leading: backButton ?? Container(),
      actions: [action ?? Container()],
    );
  }

  Widget _body(BuildContext context) {
    return Container(
        // color: Theme.of(context).appBarTheme.backgroundColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: DraggableScrollableSheet(
          maxChildSize: 1,
          initialChildSize: 1,
          minChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  // color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: body,
            );
          },
        ));
  }
}
