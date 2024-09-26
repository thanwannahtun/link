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
      this.action});

  final Widget body;
  final String title;
  Widget? action;
  Widget? backButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          children: [
                            backButton ?? Container(),
                            Text(
                              title,
                              style: TextStyle(
                                  color: context.onPrimaryColor,
                                  fontSize: AppInsets.font25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                        color: context.tertiaryColor,
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
