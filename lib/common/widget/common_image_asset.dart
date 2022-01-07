import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonImageAsset extends StatelessWidget {
  final String? imageName;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Color? color;

  const CommonImageAsset(
      {Key? key,
      this.imageName,
      this.fit = BoxFit.fill,
      this.height,
      this.width,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageName!.split('.').last != 'svg'
        ? Image.asset(
            imageName!,
            fit: fit,
            height: height,
            width: width,
            color: color,
          )
        : SvgPicture.asset(
            imageName!,
            height: height,
            width: width,
            color: color,
            fit: fit,
          );
  }
}
