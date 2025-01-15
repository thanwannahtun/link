import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? textStyle;

  const ExpandableText(
      {super.key, required this.text, this.maxLines = 2, this.textStyle});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          // style: widget.textStyle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: context.greyColor),
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (widget.text.length > 100 && widget.text.length > widget.maxLines)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "...seeLess" : "...seeMore",
              style: TextStyle(color: Colors.grey.shade300),
            ),
          ),
      ],
    );
  }
}
