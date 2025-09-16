import 'dart:io';

import 'package:dazzles/core/services/route_nav_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/navigation/presentation/navigation_screen.dart';
import 'package:dazzles/features/notification/presentation/notification_screen.dart';
import 'package:dazzles/features/profile/presentation/nav_profile_screen.dart';
import 'package:dazzles/features/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({super.key});

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  final _pages = [NavigationScreen(), NotificationScreen(), NavProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgColor,
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
    return SizedBox(
      height: Platform.isAndroid ? ResponsiveHelper.hp * .1 : null,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            height: Platform.isAndroid ? ResponsiveHelper.hp * .1 : null,
            padding: EdgeInsets.only(top: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            width: ResponsiveHelper.wp,
            child: BottomNavigationBar(
              currentIndex: ref.watch(routeNavController),
              onTap: (index) {
                ref.read(routeNavController.notifier).state = index;
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.kBgColor,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedIconTheme: IconThemeData(
                color: AppColors.kWhite,
                size: 28,
              ),
              unselectedIconTheme: IconThemeData(
                color: Colors.grey.shade400,
                size: 24,
              ),
              items: [
                BottomNavigationBarItem(
                  label: "HOME",
                  icon: Icon(SolarIconsOutline.home2),
                  activeIcon: Icon(SolarIconsBold.home2),
                ),
                BottomNavigationBarItem(
                  label: "NOTIFICATION",
                  icon: Icon(SolarIconsOutline.bell),
                  activeIcon: Icon(SolarIconsBold.bell),
                ),
                BottomNavigationBarItem(
                  label: "PROFILE",
                  icon: Icon(SolarIconsOutline.user),
                  activeIcon: Icon(SolarIconsBold.user),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
