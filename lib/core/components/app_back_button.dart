import 'package:dazzles/core/shared/theme/app_colors.dart';
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
      onPressed:goBack?? () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.kWhite,
      ),
    );
  }
}
