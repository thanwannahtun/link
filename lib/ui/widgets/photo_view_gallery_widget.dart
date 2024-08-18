import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// ignore: must_be_immutable
class PhotoViewGalleryWidget extends StatefulWidget {
  PhotoViewGalleryWidget(
      {super.key,
      required this.images,
      this.onPageChanged,
      this.pageController,
      this.backgroundDecoration});

  BoxDecoration? backgroundDecoration;
  PageController? pageController;
  final List<String> images;
  void Function(int)? onPageChanged;

  @override
  State<PhotoViewGalleryWidget> createState() => _PhotoViewGalleryWidgetState();
}

class _PhotoViewGalleryWidgetState extends State<PhotoViewGalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const ClampingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 1.3,
          // imageProvider: FileImage(File(widget.xfiles[index].path)),
          imageProvider:
              NetworkImage(widget.images[index], scale: double.maxFinite),
          initialScale: PhotoViewComputedScale.contained * 0.99,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.images[index]),
        );
      },
      itemCount: widget.images.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
          ),
        ),
      ),
      backgroundDecoration: widget.backgroundDecoration,
      pageController: widget.pageController,
      onPageChanged: widget.onPageChanged,
    );
  }
}

///
///
///
class FileViewGalleryWidget extends StatefulWidget {
  FileViewGalleryWidget(
      {super.key,
      required this.xfiles,
      this.onPageChanged,
      this.pageController,
      this.backgroundDecoration});

  BoxDecoration? backgroundDecoration;
  PageController? pageController;
  final List<XFile> xfiles;
  void Function(int)? onPageChanged;

  @override
  State<StatefulWidget> createState() => _FileViewGalleryWidgetState();
}

class _FileViewGalleryWidgetState extends State<FileViewGalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const ClampingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 1.3,
          imageProvider: FileImage(File(widget.xfiles[index].path)),
          // imageProvider:
          //     NetworkImage(widget.xfiles[index].path, scale: double.maxFinite),
          initialScale: PhotoViewComputedScale.contained * 0.99,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.xfiles[index]),
        );
      },
      itemCount: widget.xfiles.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
          ),
        ),
      ),
      backgroundDecoration: widget.backgroundDecoration,
      pageController: widget.pageController,
      onPageChanged: widget.onPageChanged,
    );
  }
}
