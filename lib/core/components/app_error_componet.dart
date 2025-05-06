import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  final String error;
  final String? errorExp;
  final Widget? icon;
  final void Function()? onRetry;

  const AppErrorView({
    super.key,
    this.icon,
    required this.error,
    this.errorExp,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              icon ??
                  Icon(
                    Icons.smart_toy_outlined,
                    color: AppColors.kTextPrimaryColor,
                    size: 70,
                  ),
              AppSpacer(hp: .01),
            ],
          ),

          Text(
            textAlign: TextAlign.center,
            error,
            style: AppStyle.largeStyle(color: AppColors.kTextPrimaryColor),
          ),

          // Subtite
          errorExp != null
              ? Column(
                children: [
                  AppSpacer(hp: .01),
                  Text(
                    textAlign: TextAlign.center,
                    errorExp!,
                    style: AppStyle.smallStyle(
                      color: AppColors.kTextPrimaryColor,
                    ),
                  ),
                ],
              )
              : SizedBox(),
          // Refresh
          onRetry != null
              ? Column(
                children: [
                  AppSpacer(hp: .01),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Try again"),
                        AppSpacer(wp: .01),
                        Icon(Icons.refresh),
                      ],
                    ),
                  ),
                ],
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
