import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<Map<String, dynamic>> data = [
    {'data': "5.8K", 'title': 'Products'},
    {'data': "200", 'title': 'Image Pending'},
    {'data': "122", 'title': 'Upcoming Products'},
    {'data': "15", 'title': 'Image Rejected'},
  ];
  @override
  Widget build(BuildContext context) {
    return AppMargin(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            AppSpacer(hp: .025),
            // Search
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

            AppSpacer(hp: .05),
            // Grid
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              itemCount: 4,
              itemBuilder:
                  (context, index) =>
                      _buildGridTile(data[index]['data'], data[index]['title']),
            ),
            AppSpacer(hp: .03),
            // Products
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recently Captured", style: AppStyle.largeStyle()),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: AppStyle.largeStyle(
                      color: AppColors.kPrimaryColor,
                      fontSize: ResponsiveHelper.fontSmall,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacer(hp: .02),
            // product Grid
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              itemCount: 2,
              itemBuilder: (context, index) => Card(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(String title, String data) => Container(
    decoration: BoxDecoration(
      color: AppColors.kSecondaryColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.kPrimaryColor.withAlpha(30),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppStyle.largeStyle(
            fontSize: ResponsiveHelper.wp * .14,
            color: AppColors.kPrimaryColor,
          ),
        ),
        AppSpacer(hp: .01),
        Text(data, style: AppStyle.mediumStyle(color: AppColors.kPrimaryColor)),
      ],
    ),
  );
}
