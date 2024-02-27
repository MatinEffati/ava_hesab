import 'package:ava_hesab/config/app_colors.dart';
import 'package:ava_hesab/core/utils/file_utility.dart';
import 'package:ava_hesab/core/widgets/ava_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NormalAppBar({
    Key? key,
    required this.title,
    this.leftIcon,
    this.leftIconAction,
    this.isShowBackButton = true,
  }) : super(key: key);
  final String title;
  final Widget? leftIcon;
  final Function()? leftIconAction;
  final bool isShowBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColorsLight.backgroundColor,
      foregroundColor: AppColorsLight.iconDefault,
      elevation: 0,
      shadowColor: Colors.transparent,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: AvaDivider(isRightPadding: false),
      ),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: isShowBackButton,
            child: InkWell(
              borderRadius: BorderRadius.circular(1000),
              onTap: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
              child: renderSvg('assets/svg/icon_back.svg'),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),
          ),
          leftIcon != null
              ? GestureDetector(
                  onTap: leftIconAction,
                  child: leftIcon,
                )
              : const SizedBox(width: 24, height: 24),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
