import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CachedImage extends StatelessWidget {
  CachedImage({
    super.key,
    required this.imageUrl,
    BoxFit this.fit = BoxFit.cover,
    BoxFit this.errorImageFit = BoxFit.cover,
    BoxFit this.placeholderImageFit = BoxFit.cover,
    this.placeholder,
  });

  final String imageUrl;
  BoxFit? fit;
  BoxFit? errorImageFit;
  BoxFit? placeholderImageFit;
  Widget Function(BuildContext, String)? placeholder;
  Widget Function(BuildContext, String, Object)? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: placeholder ??
          (context, url) => const Image(
                image: AssetImage('assets/images/loading_bg.png'),
                fit: BoxFit.cover,
              ),
      errorWidget: errorWidget ??
          (context, url, error) => Image(
              fit: errorImageFit,
              image: const AssetImage(
                'assets/icon/app_logo.jpg',
              )),
      fadeInDuration:
          const Duration(milliseconds: 500), // Smooth fade-in effect
      fadeOutDuration:
          const Duration(milliseconds: 300), // Smooth fade-out effect
    );
  }
}
