import 'dart:developer';

import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/componets.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/services/navigation_controller.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/home/data/models/dashboard_model.dart';
import 'package:dazzles/features/home/presentation/widgets/dash_board_shimmer.dart';
import 'package:dazzles/features/home/data/providers/dashboard_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<String> titles = [
    'Products',
    'Image Pending',
    'Upcoming Products',
    'Supplier Returns',
  ];

  String imageVersion = DateTime.now().microsecondsSinceEpoch.toString();
  @override
  void initState() {
    super.initState();

    // Future.microtask(
    //   () {
    //     ref.invalidate(dashboardControllerProvider);
    //   },
    // );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // final dashboardController = ref.watch(dashboardControllerProvider);
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        imageVersion = DateTime.now().microsecondsSinceEpoch.toString();
        log("refresh home");
        return ref.refresh(dashboardControllerProvider);
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: AppMargin(
          child: Column(
            children: [
              AppSpacer(hp: .01),
              // Search
              InkWell(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                onTap: () =>
                    ref.read(navigationController.notifier).state = 3,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.paddingSmall,
                    horizontal: ResponsiveHelper.paddingMedium,
                  ),
                  width: ResponsiveHelper.wp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.kFillColor.withAlpha(70),
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
        
              AppSpacer(hp: .02),
              _buildSuccessState()
              // Grid
              // BuildStateManageComponent(
              //   stateController: dashboardController,
              //   errorWidget: (p0, p1) => AppErrorView(
              //     error: p0.toString(),
              //     onRetry: () {
              //       return ref.refresh(dashboardControllerProvider);
              //     },
              //   ),
              //   successWidget: (data) => _buildSuccessState(
              //     context,
              //     data as DashboardModel,
              //     ref,
              //   ),
              //   loadingWidget: () => AppLoading(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridTile(
    String title,
    String data, {
    required void Function()? onTap,
  }) =>
      InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: onTap,
        child: Container(
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
                  fontSize: ResponsiveHelper.wp * .09,
                  color: AppColors.kPrimaryColor,
                ),
              ),
              AppSpacer(hp: .01),
              Text(
                textAlign: TextAlign.center,
                data,
                style: AppStyle.mediumStyle(color: AppColors.kPrimaryColor),
              ),
            ],
          ),
        ),
      );

  Widget _buildSuccessState() {
    final dashboardController = ref.watch(dashboardControllerProvider);

    if (dashboardController.hasError) {
      return AppErrorView(error: dashboardController.error.toString());
    }

    final model = dashboardController.value;
    bool isLoading = dashboardController.isLoading || model == null;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.kBorderColor.withAlpha(10)),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              crossAxisCount: 2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => _buildGridTile(
              onTap: () {
                switch (index) {
                  case 0:
                    {
                      ref.read(navigationController.notifier).state = 3;
                    }

                  case 1:
                    {
                      ref.read(navigationController.notifier).state = 1;
                    }

                  case 2:
                    return;

                  case 3:
                    return;
                }
              },
              isLoading
                  ? "..."
                  : '${index == 0 ? model.totalProduct : index == 1 ? model.imagePending : index == 2 ? model.upcomingProducts : model.supplierReturn}',
              titles[index],
            ),
          ),
        ),
        AppSpacer(hp: .015),
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
        AppSpacer(hp: .01),
        // product Grid
        isLoading
            ? Container(
                height: ResponsiveHelper.hp * .2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.kBorderColor.withAlpha(10)),
                child: AppLoading())
            : Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.kBorderColor.withAlpha(10)),
                child: model.recentCaptured.isEmpty
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
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            context.push(viewAndEditProductScreen, extra: {
                              "id": model.recentCaptured[index].productId,
                              "productName":
                                  model.recentCaptured[index].productName
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.kBorderColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Hero(
                                  tag: model.recentCaptured[index].productId
                                      .toString(),
                                  child: AppNetworkImage(
                                    imageVersion: imageVersion,
                                    fit: BoxFit.cover,
                                    imageFile: ApiConstants.imageBaseUrl +
                                        model.recentCaptured[index]
                                            .productPicture,
                                  ),
                                ),
                                Positioned(
                                    left: 10,
                                    top: 10,
                                    child: buildIdBadge(
                                        context,
                                        model.recentCaptured[index].productId
                                            .toString(),
                                        enableCopy: true)),
                                Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: ResponsiveHelper.wp * .42,
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 3,
                                          bottom: 3),
                                      decoration: BoxDecoration(
                                          color: AppColors.kBgColor),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            model.recentCaptured[index]
                                                .productName,
                                            style: AppStyle.mediumStyle(
                                                color: AppColors.kWhite),
                                          ),
                                          Icon(
                                            CupertinoIcons.arrow_right_circle,
                                            color: AppColors.kWhite,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
              )
      ],
    );
  }

  // Widget _buildSuccessState(
  //   BuildContext context,
  //   DashboardModel model,
  //   WidgetRef ref,
  // ) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: AppColors.kBorderColor.withAlpha(10)),
  //         child: GridView.builder(
  //           physics: NeverScrollableScrollPhysics(),
  //           padding: EdgeInsets.all(0),
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             mainAxisSpacing: 20,
  //             crossAxisSpacing: 20,
  //             crossAxisCount: 2,
  //           ),
  //           itemCount: 4,
  //           itemBuilder: (context, index) => _buildGridTile(
  //             onTap: () {
  //               switch (index) {
  //                 case 0:
  //                   {
  //                     ref.read(navigationController.notifier).state = 3;
  //                   }

  //                 case 1:
  //                   {
  //                     ref.read(navigationController.notifier).state = 1;
  //                   }

  //                 case 2:
  //                   return;

  //                 case 3:
  //                   return;
  //               }
  //             },
  //             '${index == 0 ? model.totalProduct : index == 1 ? model.imagePending : index == 2 ? model.upcomingProducts : model.supplierReturn}',
  //             titles[index],
  //           ),
  //         ),
  //       ),
  //       AppSpacer(hp: .015),
  //       // Products
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text("Recently Captured", style: AppStyle.largeStyle()),
  //           TextButton(
  //             onPressed: () {
  //               context.push(recentlyCaptured);
  //             },
  //             child: Text(
  //               "View All",
  //               style: AppStyle.largeStyle(
  //                 color: AppColors.kPrimaryColor,
  //                 fontSize: ResponsiveHelper.fontSmall,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       AppSpacer(hp: .01),
  //       // product Grid
  //       Container(
  //         padding: EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: AppColors.kBorderColor.withAlpha(10)),
  //         child: model.recentCaptured.isEmpty
  //             ? AppErrorView(error: "Nothing is captured recently")
  //             : GridView.builder(
  //                 physics: NeverScrollableScrollPhysics(),
  //                 padding: EdgeInsets.all(0),
  //                 shrinkWrap: true,
  //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                   mainAxisSpacing: 20,
  //                   crossAxisSpacing: 20,
  //                   crossAxisCount: 2,
  //                 ),
  //                 itemCount: model.recentCaptured.length,
  //                 itemBuilder: (context, index) => InkWell(
  //                   onTap: () {
  //                     context.push(viewAndEditProductScreen, extra: {
  //                       "id": model.recentCaptured[index].productId,
  //                       "productName": model.recentCaptured[index].productName
  //                     });
  //                   },
  //                   child: Container(

  //                     decoration: BoxDecoration(
  //                       color: AppColors.kBorderColor,
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     clipBehavior: Clip.antiAlias,
  //                     child: Stack(
  //                       fit: StackFit.expand,
  //                       children: [
  //                         Hero(
  //                           tag: model.recentCaptured[index].productId
  //                               .toString(),
  //                           child: AppNetworkImage(
  //                             imageVersion: imageVersion,
  //                             fit: BoxFit.cover,
  //                             imageFile: ApiConstants.imageBaseUrl +
  //                                 model.recentCaptured[index].productPicture,
  //                           ),
  //                         ),
  //                         Positioned(
  //                             left: 10,
  //                             top: 10,
  //                             child: buildIdBadge(
  //                                 context,
  //                                 model.recentCaptured[index].productId
  //                                     .toString(),
  //                                 enableCopy: true)),
  //                         Positioned(
  //                             bottom: 0,
  //                             child: Container(
  //                                 width: ResponsiveHelper.wp*.42,
  //                               padding: EdgeInsets.only(
  //                                   left: 15, right: 15, top: 3, bottom: 3),
  //                               decoration:
  //                                   BoxDecoration(color: AppColors.kBgColor),
  //                               child: Row(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                     model.recentCaptured[index].productName,
  //                                     style: AppStyle.mediumStyle(
  //                                         color: AppColors.kWhite),
  //                                   ),
  //                                   Icon(
  //                                     CupertinoIcons.arrow_right_circle,
  //                                     color: AppColors.kWhite,
  //                                     size: 18,
  //                                   )
  //                                 ],
  //                               ),
  //                             ))
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //       )
  //     ],
  //   );
  // }
}
