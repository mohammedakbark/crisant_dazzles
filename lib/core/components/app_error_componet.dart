import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

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
    bool isTokenExpire = error == "jwt expired" ? true : false;
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              icon ??
                  Icon(
                      error == "No Internet Connection!"
                          ? Icons.wifi_off
                          : Icons.error_outline_outlined,
                      size: 70,
                      color: AppColors.kTextPrimaryColor),
              AppSpacer(hp: .03),
            ],
          ),

          Text(
            textAlign: TextAlign.center,
            isTokenExpire ? "Session is expired." : error,
            style: AppStyle.largeStyle(
                fontSize: ResponsiveHelper.isTablet()
                    ? ResponsiveHelper.fontSmall
                    : null,
                color: AppColors.kTextPrimaryColor),
          ),

          // Subtite
          isTokenExpire
              ? Column(
                  children: [
                    AppSpacer(hp: .005),
                    Text(
                      textAlign: TextAlign.center,
                      "Please login again..",
                      style: AppStyle.smallStyle(
                        fontSize: ResponsiveHelper.isTablet()
                            ? ResponsiveHelper.fontSmall
                            : null,
                        color: AppColors.kTextPrimaryColor,
                      ),
                    ),
                  ],
                )
              : SizedBox(),

          // Token - Expired

          errorExp != null
              ? Column(
                  children: [
                    AppSpacer(hp: .01),
                    Text(
                      textAlign: TextAlign.center,
                      errorExp!,
                      style: AppStyle.smallStyle(
                        fontSize: ResponsiveHelper.isTablet()
                            ? ResponsiveHelper.fontSmall
                            : null,
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
                      onPressed: isTokenExpire
                          ? () => ProfilePage.logout(context)
                          : onRetry,
                      child: Padding(
                        padding: EdgeInsets.all(
                            ResponsiveHelper.isTablet() ? 20 : 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection:
                              isTokenExpire ? TextDirection.rtl : null,
                          children: [
                            Text(
                              isTokenExpire ? "Logout" : "Try again",
                              style: AppStyle.boldStyle(
                                color: AppColors.kPrimaryColor,
                                fontSize: ResponsiveHelper.isTablet()
                                    ? ResponsiveHelper.fontSmall
                                    : null,
                              ),
                            ),
                            AppSpacer(wp: .01),
                            Icon(
                                size: ResponsiveHelper.isTablet() ? 40 : null,
                                isTokenExpire
                                    ? SolarIconsOutline.logout
                                    : Icons.refresh),
                          ],
                        ),
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
