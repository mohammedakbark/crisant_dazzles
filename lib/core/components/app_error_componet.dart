import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/services/navigation_controller.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/office/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                    Icons.smart_toy_outlined,
                    color: AppColors.kTextPrimaryColor,
                    size: 70,
                  ),
              AppSpacer(hp: .01),
            ],
          ),

          Text(
            textAlign: TextAlign.center,
            isTokenExpire ? "Session is expired." : error,
            style: AppStyle.largeStyle(color: AppColors.kTextPrimaryColor),
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
                      onPressed:
                          isTokenExpire ? () =>ProfilePage.logout(context) : onRetry,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: isTokenExpire?TextDirection.rtl:null,
                        children: [
                          Text(isTokenExpire ? "Logout" : "Try again"),
                          AppSpacer(wp: .01),
                          Icon( isTokenExpire? SolarIconsOutline.logout: Icons.refresh),
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
