import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? bgColor;
  final String title;
  final Color? textColor;
  const AppButton(
      {super.key,
      this.onPressed,
      required this.title,
      this.bgColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.wp,
      height: ResponsiveHelper.hp * .06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColors.kPrimaryColor,
        ),
        onPressed: onPressed,
        child: Text(title,
            style: AppStyle.largeStyle(
                fontSize: ResponsiveHelper.isTablet()
                    ? ResponsiveHelper.fontSmall
                    : null,
                color: textColor ?? AppColors.kBgColor)),
      ),
    );
  }
}
