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
// ignore: must_be_immutable
class FileViewGalleryWidget extends StatefulWidget {
  FileViewGalleryWidget({
    super.key,
    required this.xfiles,
    this.onPhotoDeleted,
    this.onPageChanged,
    this.pageController,
    this.backgroundDecoration,
  });

  BoxDecoration? backgroundDecoration;
  PageController? pageController;
  final List<XFile> xfiles;
  void Function(int)? onPageChanged;
  ValueChanged<int>? onPhotoDeleted;

  @override
  State<StatefulWidget> createState() => _FileViewGalleryWidgetState();
}

class _FileViewGalleryWidgetState extends State<FileViewGalleryWidget> {
  bool showAppBar = false;
  int? currentIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild Gallery");
    return Builder(builder: (context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) rebuild) {
          return Scaffold(
            appBar: showAppBar
                ? AppBar(
                    actions: [
                      IconButton.filled(
                          onPressed: () {
                            rebuild(() {
                              widget.onPhotoDeleted!(currentIndex!);
                              widget.xfiles.removeAt(currentIndex ??
                                  widget.xfiles.indexOf(widget.xfiles.last));
                            });
                          },
                          icon: const Icon(Icons.delete_forever_sharp))
                    ],
                  )
                : null,
            body: PhotoViewGallery.builder(
              scrollPhysics: const ClampingScrollPhysics(),
              // scaleStateChangedCallback: (value) =>
              // scale state = zoomIn or zoomOut
              //     print("scaleState changed :: $value"),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 1.3,
                  imageProvider: FileImage(File(widget.xfiles[index].path)),
                  // imageProvider:
                  //     NetworkImage(widget.xfiles[index].path, scale: double.maxFinite),
                  initialScale: PhotoViewComputedScale.contained * 0.99,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: widget.xfiles[index]),
                  gestureDetectorBehavior: HitTestBehavior.deferToChild,
                  onTapUp: (context, details, controllerValue) {
                    print("onTapUp");

                    rebuild(() {
                      currentIndex = index;
                      showAppBar = true;
                    });
                  },
                  onTapDown: (context, details, controllerValue) {
                    print("onTapDown");
                    rebuild(() {
                      showAppBar = false;
                    });
                  },
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
                        : event.cumulativeBytesLoaded /
                            (event.expectedTotalBytes ?? 0),
                  ),
                ),
              ),
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: widget.onPageChanged,
            ),
          );
        },
      );
    });
  }
}
