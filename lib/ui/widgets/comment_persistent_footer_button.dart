import 'package:flutter/material.dart';

class CommentPersistentFooterButton extends StatelessWidget {
  CommentPersistentFooterButton(
      {super.key,
      this.onIconPressed,
      this.onEditingComplete,
      this.hintText,
      this.autofocus = false});

  void Function()? onIconPressed;
  void Function()? onEditingComplete;
  String? hintText;
  bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
            onPressed: onIconPressed, icon: const Icon(Icons.image)),
        Flexible(
          // Use Flexible instead of Expanded
          child: TextField(
            autofocus: autofocus,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: onEditingComplete,
                icon: const Icon(Icons.send),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              filled: true,
              fillColor: Colors.black12,
              hintText: hintText ?? "Leave a comment...",
            ),
          ),
        )
      ],
    );
  }
}
