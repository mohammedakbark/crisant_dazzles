import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: AppMargin(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.paddingSmall,
                horizontal: ResponsiveHelper.paddingMedium,
              ),
              width: ResponsiveHelper.wp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.kFillColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Global Search",
                    style: AppStyle.normalStyle(color: AppColors.kPrimaryColor),
                  ),
                  Icon(
                    SolarIconsOutline.magnifier,
                    color: AppColors.kPrimaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
