import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture renderSvg(
  String assetPath, {
  Color? color,
  bool isCover = false,
  double? width,
  double? height,
}) {
  return SvgPicture.asset(
    assetPath,
    height: height,
    width: width,
    fit: (isCover) ? BoxFit.cover : BoxFit.contain,
  );
}
