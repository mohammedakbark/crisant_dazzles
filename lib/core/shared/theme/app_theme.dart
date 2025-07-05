import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData() => ThemeData(
        textTheme: AppTheme.buildTextTheme(
          AppStyle.smallStyle(),
          AppStyle.mediumStyle(),
          AppStyle.largeStyle(),
        ),
        scaffoldBackgroundColor: AppColors.kBgColor,
        appBarTheme: AppBarTheme(
            toolbarHeight: ResponsiveHelper.isTablet() ? 100 : null,
            centerTitle: false,
            backgroundColor: AppColors.kBgColor),
        colorScheme: ColorScheme.dark(primary: AppColors.kPrimaryColor),
      );

  static TextTheme buildTextTheme(
    TextStyle small,
    TextStyle medium,
    TextStyle large,
  ) {
    return TextTheme(
      titleSmall: small,
      titleMedium: medium,
      titleLarge: large,
      bodySmall: small,
      bodyMedium: medium,
      bodyLarge: large,
      displaySmall: small,
      displayMedium: medium,
      displayLarge: large,
      headlineSmall: small,
      headlineMedium: medium,
      headlineLarge: large,
      labelSmall: small,
      labelMedium: medium,
      labelLarge: large,
    );
  }
}
