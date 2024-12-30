import 'package:flutter/material.dart';

class LikeIcon extends StatefulWidget {
  const LikeIcon(
      {super.key,
      this.isLike = false,
      required this.toggleLike,
      this.onMiddleWareFailed,
      this.middleWare});

  // Initial 'like' state
  final bool isLike;

  // External function that accepts the updated 'like' state
  final void Function(bool isLiked) toggleLike;
  final VoidCallback? onMiddleWareFailed;
  final bool Function()? middleWare;

  @override
  State<LikeIcon> createState() => _LikeIconState();
}

class _LikeIconState extends State<LikeIcon> {
  late final ValueNotifier<bool> _likeNotifier;

  @override
  void initState() {
    super.initState();
    // Initialize ValueNotifier with the initial like state
    _likeNotifier = ValueNotifier(widget.isLike);
  }

  // Clean up ValueNotifier to avoid memory leaks
  @override
  void dispose() {
    _likeNotifier.dispose();
    super.dispose();
  }

  // Toggle the like state internally and pass the new value to the external callback
  void _toggleLike() {
    if (widget.middleWare?.call() ?? true) {
      _likeNotifier.value = !_likeNotifier.value;
      widget.toggleLike(_likeNotifier.value); // Pass the updated state
    } else {
      widget.onMiddleWareFailed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleLike, // Call the internal toggle function
      icon: ValueListenableBuilder<bool>(
        valueListenable: _likeNotifier,
        builder: (context, value, child) {
          return Icon(
            value ? Icons.recommend : Icons.recommend_sharp,
            color: value
                ? Colors.blue
                : Colors.grey, // Change color based on state
            size: 20,
          );
        },
      ),
    );
  }
}
