import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? bgColor;
  final String title;
  const AppButton({
    super.key,
    this.onPressed,
    required this.title,
     this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.wp,
      height: ResponsiveHelper.hp * .07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColors.kPrimaryColor,
        ),
        onPressed: onPressed,
        child: Text(title, style: AppStyle.largeStyle(color: AppColors.kBgColor)),
      ),
    );
  }
}
