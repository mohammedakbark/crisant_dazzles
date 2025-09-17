import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final String? buttonTitle;
  final bool? hideShadow;

  final void Function()? onTap;
  final void Function()? goBack;

  const AppBackButton({
    super.key,
    this.buttonTitle,
    this.onTap,
    this.goBack,
    this.hideShadow,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: goBack ?? () => Navigator.pop(context),
      icon: Icon(
        size: ResponsiveHelper.isTablet() ? 40 : null,
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.kWhite,
      ),
    );
  }
}

class AppBarText extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const AppBarText({super.key, required this.title,this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTab=ResponsiveHelper.isTablet();
    return InkWell(
      onTap:onTap ,
      child: Text(title, style: AppStyle.boldStyle(fontSize: isTab?ResponsiveHelper.fontSmall:null)));
  }
}
