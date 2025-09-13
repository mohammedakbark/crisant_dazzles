import 'dart:io';

import 'package:dazzles/core/services/route_nav_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/navigation/presentation/navigation_screen.dart';
import 'package:dazzles/features/profile/presentation/nav_profile_screen.dart';
import 'package:dazzles/module/office/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({super.key});

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  final _pages = [NavigationScreen(), NavProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pages.length - 1 != ref.watch(routeNavController)
          ? CustomAppBar()
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
              padding: EdgeInsets.only(
                bottom: Platform.isAndroid
                    ? ResponsiveHelper.hp * .09
                    : ResponsiveHelper.hp * .1,
              ),
              child: _pages[ref.watch(routeNavController)]),
          Positioned(bottom: 0, child: _buildCustomeNav())
        ],
      ),
    );
  }

  Widget _buildCustomeNav() {
    final isTab = ResponsiveHelper.isTablet();
    return SizedBox(
      height: Platform.isAndroid
          ? ResponsiveHelper.hp * .12
          : ResponsiveHelper.hp * .14,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.only(top: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.kSecondaryColor,
            ),
            width: ResponsiveHelper.wp,
            height: Platform.isAndroid
                ? ResponsiveHelper.hp * .09
                : ResponsiveHelper.hp * .1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconSet(SolarIconsBold.home, "Home", 0),
                    _buildIconSet(CupertinoIcons.profile_circled, "Profile", 1)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconSet(IconData icon, String label, int index) {
    final isTab = ResponsiveHelper.isTablet();
    bool isSelected = ref.read(routeNavController.notifier).state == index;
    return IconButton(
        onPressed: () {
          ref.read(routeNavController.notifier).state = index;
        },
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isTab ? 50 : null,
              color: isSelected ? AppColors.kPrimaryColor : AppColors.kWhite,
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
}
