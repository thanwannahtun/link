import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';

import '../../core/utils/app_insets.dart';

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
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox.expand(
                child: Container(
                  height: 50,
                  color: context.secondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppInsets.inset10,
                        vertical: AppInsets.inset15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [backButton ?? Container(), title],
                        ),
                        action ?? Container()
                      ],
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                maxChildSize: 0.9,
                initialChildSize: 0.9,
                minChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                        // color: context.primaryColor,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                    child: body,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
