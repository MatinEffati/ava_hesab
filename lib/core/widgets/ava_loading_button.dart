import 'package:ava_hesab/core/utils/file_utility.dart';
import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

class AvaLoadingButton extends StatelessWidget {
  final bool isLoading;
  final bool isDisabled;
  final bool isLight;
  final bool hasTextStyle;
  final VoidCallback? onPressed;

  final Color? color;
  final TextStyle? textStyle;

  final double marginTop;
  final double marginLeft;
  final double marginRight;
  final double marginBottom;

  final String title;
  final String? svgButton;

  const AvaLoadingButton({
    this.textStyle,
    this.color,
    required this.title,
    this.isLoading = false,
    this.isDisabled = false,
    this.hasTextStyle = false,
    required this.onPressed,
    this.marginTop = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    Key? key,
    this.isLight = false,
    this.svgButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom),
      child: ElevatedButton(
        style: isDisabled
            ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColorsLight.gray),
                foregroundColor: MaterialStateProperty.all(AppColorsLight.textOnPrimary),
                minimumSize: MaterialStateProperty.all(const Size(double.infinity, 48)),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: AppColorsLight.primaryColor,
                disabledBackgroundColor: AppColorsLight.gray,
                disabledForegroundColor: AppColorsLight.black20,
                minimumSize: const Size(double.infinity, 48),
              ),
        onPressed: !isLoading ? onPressed ?? null : null,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (svgButton != null) renderSvg(svgButton!),
                  if (svgButton != null) const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColorsLight.textOnPrimary,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
