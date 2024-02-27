import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

class AvaDivider extends StatelessWidget {
  const AvaDivider({
    super.key,
    this.isRightPadding = true,
    this.color = AppColorsLight.divider,
  });

  final bool isRightPadding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isRightPadding ? 16 : 0),
      child: Container(
        width: double.infinity,
        height: 0.5,
        // margin: EdgeInsets.only(right: isRightPadding ? 16 : 0),
        color: color,
      ),
    );
  }
}
