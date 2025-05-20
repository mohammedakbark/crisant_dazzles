import 'dart:developer';
import 'dart:io';

import 'package:dazzles/core/services/navigation_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/camera/data/providers/camera_controller.dart';
import 'package:dazzles/features/camera/presentation/camera_screen.dart';
import 'package:dazzles/features/custom_app_bar.dart';
import 'package:dazzles/features/home/presentation/home_page.dart';
import 'package:dazzles/features/home/data/providers/dashboard_controller.dart';
import 'package:dazzles/features/product/presentation/products_page.dart';
import 'package:dazzles/features/product/data/providers/product_controller/get_products_controller.dart';
import 'package:dazzles/features/profile/presentation/profile_page.dart';
import 'package:dazzles/features/profile/data/providers/get_profile_controller.dart';
import 'package:dazzles/features/pending/presentation/pending_image_page.dart';
import 'package:dazzles/features/pending/data/providers/get%20pending%20products/get_pending_products_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:badges/badges.dart' as badges;

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  final List<Widget> _pages = [
    HomePage(),
    PendingImagePage(),
    CameraScreen(),
    ProductsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(dashboardControllerProvider);
      ref.invalidate(profileControllerProvider);
      ref.invalidate(getAllPendingProductControllerProvider);
      ref.invalidate(allProductControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(navigationController);
    return Scaffold(
      appBar: index == 4 ? null : CustomAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
              padding: EdgeInsets.only(
                bottom: Platform.isAndroid
                    ? ResponsiveHelper.hp * .09
                    : ResponsiveHelper.hp * .12,
              ),
              child: _pages[index]),
          Positioned(bottom: 0, child: _buildCustomeNav())
        ],
      ),
    );
  }

  Widget _buildCustomeNav() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
      ),
      width: ResponsiveHelper.wp,
      height: Platform.isAndroid
          ? ResponsiveHelper.hp * .09
          : ResponsiveHelper.hp * .12,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconSet(SolarIconsBold.home, "Home", 0),
                _buildIconSet(CupertinoIcons.square_list_fill, "Pending", 1),
                SizedBox(
                  width: ResponsiveHelper.wp * .1,
                ),
                _buildIconSet(CupertinoIcons.cart_fill, "Products", 3),
                _buildIconSet(CupertinoIcons.profile_circled, "Profile", 4)
              ],
            ),
          ),
          Positioned(
              top: -30,
              child: InkWell(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                onTap: () async {
                  log("dddhd");
                  if (ref.watch(navigationController) == 2) {
                    ref.watch(camaraButtonScaleController.notifier).state = 0.9;
                    await Future.delayed(Duration(microseconds: 500));
                    ref.watch(camaraButtonScaleController.notifier).state  = 1.0;
                    await ref
                        .read(cameraControllerProvider.notifier)
                        .takePhoto(context);
                  } else {
                    ref.watch(navigationController.notifier).state = 2;
                  }
                },
                child: AnimatedScale(
                  scale: ref.watch(camaraButtonScaleController),
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: Container(
                    width: ResponsiveHelper.wp * .3,
                    height: ResponsiveHelper.wp * .18,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            width: 4,
                            color: ref
                                        .watch(navigationController.notifier)
                                        .state ==
                                    2
                                ? AppColors.kPrimaryColor
                                : AppColors.kWhite),
                        shape: BoxShape.circle),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: AppColors.kSecondaryColor,
                            // color: ref
                            //             .watch(navigationController.notifier)
                            //             .state ==
                            //         2
                            //     ? AppColors.kWhite
                            //     : AppColors.kSecondaryColor
                          ),
                          color:
                              ref.watch(navigationController.notifier).state ==
                                      2
                                  ? AppColors.kPrimaryColor
                                  : AppColors.kWhite,
                          shape: BoxShape.circle),
                      child: Icon(
                        CupertinoIcons.camera_fill,
                        color:
                            ref.watch(navigationController.notifier).state == 2
                                ? AppColors.kWhite
                                : AppColors.kBgColor,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildIconSet(IconData icon, String label, int index) {
    bool isSelected = ref.read(navigationController.notifier).state == index;
    return IconButton(
        onPressed: () {
          ref.read(navigationController.notifier).state = index;
        },
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            index == 1
                ? _buildBadge(
                    Icon(
                      icon,
                      color: isSelected
                          ? AppColors.kPrimaryColor
                          : AppColors.kWhite,
                    ),
                  )
                : Icon(
                    icon,
                    color:
                        isSelected ? AppColors.kPrimaryColor : AppColors.kWhite,
                  ),
            Text(
              label,
              style: AppStyle.boldStyle(
                fontSize: ResponsiveHelper.fontSmall,
                color: isSelected ? AppColors.kPrimaryColor : AppColors.kWhite,
              ),
            )
          ],
        ));
  }

  Widget _buildBadge(Widget child) {
    int? data = 0;
    try {
      data = ref.watch(dashboardControllerProvider).value?.imagePending;
    } catch (e) {
      data = 0;
    }
    return badges.Badge(
      showBadge: data != 0,
      badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent),
      badgeContent: Text(
        data != null ? data.toString() : "0",
        style: AppStyle.mediumStyle(fontSize: 8),
      ),
      position: badges.BadgePosition.topEnd(end: -10, top: -8),
      badgeAnimation: badges.BadgeAnimation.slide(
        curve: Curves.fastOutSlowIn,
        colorChangeAnimationCurve: Curves.easeInCubic,
      ),
      child: child,
    );
  }
}
