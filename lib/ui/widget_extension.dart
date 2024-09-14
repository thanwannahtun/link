import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget padding({required EdgeInsetsGeometry padding}) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget clipRRect({
    Key? key,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      clipper: clipper,
      child: this,
    );
  }

  Widget sizedBox({
    Key? key,
    double? width,
    double? height,
    Widget? child,
  }) {
    return SizedBox(
      width: width,
      height: height,
      key: key,
      child: this,
    );
  }

  Widget center({
    Key? key,
    double? widthFactor,
    double? heightFactor,
  }) {
    return Center(
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      key: key,
      child: this,
    );
  }

  Widget expanded({
    Key? key,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      key: key,
      child: this,
    );
  }
}

extension NumExtension on num {
  SizedBox sizedBox({double? height, double? width, Widget? child}) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}

extension StyleExtension on Text {
  Text bold({TextAlign? textAlign}) {
    return Text(
      data ?? "",
      textAlign: textAlign,
      style: style?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
