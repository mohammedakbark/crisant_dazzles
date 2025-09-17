import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/profile/presentation/profile_page.dart';
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
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    bool isTokenExpire = error == "jwt expired" ? true : false;
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: icon ??
                    Icon(
                        error == "No Internet Connection!"
                            ? Icons.wifi_off
                            : Icons.error_outline_outlined,
                        size: 50,
                        color: AppColors.kTextPrimaryColor),
              ),
              AppSpacer(hp: .03),
            ],
          ),

          Text(
            textAlign: TextAlign.center,
            isTokenExpire ? "Session is expired." : error,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              // fontSize: ResponsiveHelper.isTablet()
              //     ? ResponsiveHelper.fontSmall
              //     : null,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),

          // Subtite
          isTokenExpire
              ? Column(
                  children: [
                    AppSpacer(hp: .005),
                    Text(
                      textAlign: TextAlign.center,
                      "Please login again..",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        // fontSize: ResponsiveHelper.isTablet()
                        //     ? ResponsiveHelper.fontSmall
                        //     : null,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        // fontSize: ResponsiveHelper.isTablet()
                        //     ? ResponsiveHelper.fontSmall
                        //     : null,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          // Refresh
          onRetry != null
              ? Column(
                  children: [
                    AppSpacer(hp: .03),
                    InkWell(
                      onTap: isTokenExpire
                          ? () => NavProfileScreen.logout(context)
                          : onRetry,
                      child: Padding(
                        padding: EdgeInsets.all(
                            ResponsiveHelper.isTablet() ? 20 : 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection:
                              isTokenExpire ? TextDirection.rtl : null,
                          children: [
                            Icon(
                                size: ResponsiveHelper.isTablet() ? 40 : 18,
                                color: AppColors.kDeepPurple,
                                isTokenExpire
                                    ? SolarIconsOutline.logout
                                    : Icons.refresh),
                            AppSpacer(wp: .01),
                            Text(
                              isTokenExpire ? "Logout" : "Refresh",
                              style: AppStyle.boldStyle(
                                color: AppColors.kDeepPurple,
                                fontSize: ResponsiveHelper.isTablet()
                                    ? ResponsiveHelper.fontSmall
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacer(hp: .03),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
// Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: isDark ? Colors.grey[800] : Colors.grey[100],
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Icon(
//               Icons.notifications_none_rounded,
//               size: 48,
//               color: isDark ? Colors.grey[400] : Colors.grey[500],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "No notifications yet",
//             style: theme.textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: isDark ? Colors.grey[300] : Colors.grey[700],
//             ),
//           ),
