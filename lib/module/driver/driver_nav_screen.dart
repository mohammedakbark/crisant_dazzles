import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/services/driver_nav_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/driver/home/presentation/driver_home.dart';
import 'package:dazzles/module/other%20roles%20modules/other_users_navigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';

class DriverNavScreen extends StatelessWidget {
  DriverNavScreen({super.key});
  final _pages = [DriverHome(), OtherUsersNaviagationScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Consumer(builder: (context, ref, _) {
          return ref.watch(driverNavigationController) == 0
              ? FadeIn(
                  key: GlobalObjectKey(ref.watch(driverNavigationController)),
                  child: Text(
                    'Dashboard',
                    style: AppStyle.boldStyle(
                      fontSize: 24,
                      color: AppColors.kWhite,
                    ),
                  ),
                )
              : FadeIn(
                  key: GlobalObjectKey(ref.watch(driverNavigationController)),
                  child: Text(
                    'Profile',
                    style: AppStyle.boldStyle(
                      fontSize: 24,
                      color: AppColors.kWhite,
                    ),
                  ),
                );
        }),
        // centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, _) {
        return _pages[ref.watch(driverNavigationController)];
      }),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          return Container(
            height: Platform.isAndroid?ResponsiveHelper.hp*.1:null,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: ref.watch(driverNavigationController),
              onTap: (index) {
                ref.watch(driverNavigationController.notifier).state = index;
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
                  label: "PROFILE",
                  icon: Icon(SolarIconsOutline.user),
                  activeIcon: Icon(SolarIconsBold.user),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
