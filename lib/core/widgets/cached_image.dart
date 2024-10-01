import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CachedImage extends StatelessWidget {
  CachedImage({
    super.key,
    required this.imageUrl,
    BoxFit fit = BoxFit.contain,
    BoxFit errorImageFit = BoxFit.contain,
    BoxFit placeholderImageFit = BoxFit.contain,
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
      fit: placeholderImageFit,
      placeholder: placeholder ??
          (context, url) => const Image(
                image: AssetImage('assets/icon/app_logo.jpg'),
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
