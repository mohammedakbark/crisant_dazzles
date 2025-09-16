import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/services/office_navigation_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/home/data/providers/dashboard_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';

class DashboardGrid extends ConsumerWidget {
  DashboardGrid({super.key});
  final List<String> titles = [
    'Image Pending',
    'Upcoming Products',
    'Supplier Returns',
  ];
  @override
  Widget build(BuildContext context, ref) {
    final isTab = ResponsiveHelper.isTablet();
    final dashboardController = ref.watch(dashboardControllerProvider);
    if (dashboardController.hasError) {
      return AppErrorView(error: dashboardController.error.toString());
    }

    final model = dashboardController.value;
    bool isLoading = dashboardController.isLoading || model == null;
    return Column(
      children: [
        Row(
          children: [
            const Icon(SolarIconsBold.pieChart, size: 16),
            const SizedBox(width: 8),
            Text("Dashboard", style: AppStyle.boldStyle(fontSize: 16)),
            const SizedBox(width: 12),
            const Flexible(
              child: Divider(height: 0, color: AppColors.kGrey),
            ),
          ],
        ),
        AppSpacer(hp: .02),
        Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.kBorderColor.withAlpha(10)),
            child: Column(
              children: [
                _buildGridTile(
                  isLoading ? "..." : model.totalProduct.toString(),
                  "Products",
                ),
                AppSpacer(
                  hp: .02,
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      crossAxisCount: 3),
                  itemCount: titles.length,
                  itemBuilder: (context, index) => _buildGridTile(
                    isLoading
                        ? "..."
                        : '${index == 0 ? model.imagePending : index == 1 ? model.upcomingProducts : model.supplierReturn}',
                    titles[index],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildGridTile(
    String title,
    String data,
  ) {
    final isTab = ResponsiveHelper.isTablet();
    return Container(
      width: ResponsiveHelper.wp,
      height: ResponsiveHelper.hp * .12,
      padding: EdgeInsets.all(ResponsiveHelper.paddingMedium),
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
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            title,
            style: AppStyle.largeStyle(
              fontSize: ResponsiveHelper.wp * .06,
              color: AppColors.kPrimaryColor,
            ),
          ),
          Flexible(
            child: Text(
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              data,
              style: AppStyle.mediumStyle(
                  fontSize: ResponsiveHelper.fontSmall,
                  color: AppColors.kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
