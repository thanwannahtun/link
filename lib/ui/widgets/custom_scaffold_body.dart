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
      this.persistentFooterButtons});

  final Widget body;
  final Widget title;
  Widget? action;
  bool? resizeToAvoidBottomInset;
  Widget? backButton;
  List<Widget>? persistentFooterButtons;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        persistentFooterButtons: persistentFooterButtons,
        appBar: _appBar(),
        body: _body(context),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: title,
      leadingWidth: backButton != null ? 56 : 0.0, // 56 == default
      automaticallyImplyLeading: true,
      leading: backButton ?? Container(),
      actions: [action ?? Container()],
    );
  }

  Container _body(BuildContext context) {
    return Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: DraggableScrollableSheet(
          maxChildSize: 1,
          initialChildSize: 1,
          minChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: body,
            );
          },
        ));
  }
}
