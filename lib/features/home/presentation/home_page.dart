import 'dart:developer';

import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/home/data/models/dashboard_model.dart';
import 'package:dazzles/features/home/presentation/widgets/dash_board_shimmer.dart';
import 'package:dazzles/features/home/providers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  List<String> titles = [
    'Products',
    'Image Pending',
    'Upcoming Products',
    'Image Rejected',
  ];
  @override
  Widget build(BuildContext context, ref) {
    final dashboardController = ref.watch(dashboardControllerProvider);
    return RefreshIndicator(
      onRefresh: () async {
        return ref.refresh(dashboardControllerProvider);
      },

      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: AppMargin(
          child: Column(
            children: [
              AppSpacer(hp: .025),
              // Search
              InkWell(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                onTap: () => context.push(searchScreen),
                child: Container(
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
                        style: AppStyle.normalStyle(
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                      Icon(
                        SolarIconsOutline.magnifier,
                        color: AppColors.kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),

              AppSpacer(hp: .05),
              // Grid
              BuildStateManageComponent(
                controller: dashboardController,
                errorWidget:
                    (p0, p1) => AppErrorView(
                      error: p0.toString(),

                      onRetry: () {
                        return ref.refresh(dashboardControllerProvider);
                      },
                    ),
                successWidget:
                    (data) =>
                        _buildSuccessState(context, data as DashboardModel),
                loadingWidget: () => DashBoardShimmer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridTile(String title, String data) => Container(
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
          overflow: TextOverflow.ellipsis,
          title,
          style: AppStyle.largeStyle(
            fontSize: ResponsiveHelper.wp * .12,
            color: AppColors.kPrimaryColor,
          ),
        ),
        AppSpacer(hp: .01),
        Text(data, style: AppStyle.mediumStyle(color: AppColors.kPrimaryColor)),
      ],
    ),
  );

  Widget _buildSuccessState(BuildContext context, DashboardModel model) {
    return Column(
      children: [
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
              (context, index) => _buildGridTile(
                '${index == 0
                    ? model.totalProduct
                    : index == 1
                    ? model.imagePending
                    : index == 2
                    ? model.upcomingProducts
                    : model.imageRejected}',
                titles[index],
              ),
        ),
        AppSpacer(hp: .03),
        // Products
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recently Captured", style: AppStyle.largeStyle()),
            TextButton(
              onPressed: () {
                context.push(recentlyCaptured);
              },
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
        model.recentCaptured.isEmpty
            ? AppErrorView(error: "Nothing is captured recently")
            : GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              itemCount: model.recentCaptured.length,
              itemBuilder:
                  (context, index) => Container(
                    decoration: BoxDecoration(
                      color: AppColors.kBgColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          color: AppColors.kPrimaryColor,
                        ),
                      ],
                      // border: Border.all(color: AppColors.kPrimaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppNetworkImage(
                      fit: BoxFit.cover,
                      imageFile:
                          ApiConstants.imageBaseUrl +
                          model.recentCaptured[index].productPicture,
                    ),
                  ),
            ),
      ],
    );
  }
}
