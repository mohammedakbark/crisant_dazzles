import 'package:dazzles/core/services/navigation_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/custom_app_bar.dart';
import 'package:dazzles/features/home/presentation/home_page.dart';
import 'package:dazzles/features/home/data/providers/dashboard_controller.dart';
import 'package:dazzles/features/product/presentation/products_page.dart';
import 'package:dazzles/features/product/data/providers/product_controller/get_products_controller.dart';
import 'package:dazzles/features/profile/presentation/profile_page.dart';
import 'package:dazzles/features/profile/data/providers/get_profile_controller.dart';
import 'package:dazzles/features/upload/presentation/pending_image_page.dart';
import 'package:dazzles/features/upload/data/providers/get%20pending%20products/get_pending_products_controller.dart';
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
    int index = ref.read(navigationController.notifier).state;
    return Scaffold(
      appBar: index == 3 ? null : CustomAppBar(),
      body: _pages[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveHelper.borderRadiusLarge),
          topRight: Radius.circular(ResponsiveHelper.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(boxShadow: [BoxShadow()]),
          height: ResponsiveHelper.hp * .09,
          child: BottomNavigationBar(
            onTap: (value) {
              ref.read(navigationController.notifier).state = value;
            },
            currentIndex: ref.watch(navigationController),
            iconSize: 28,
            selectedLabelStyle: AppStyle.boldStyle(
              fontSize: ResponsiveHelper.fontExtraSmall,
            ),
            unselectedLabelStyle: AppStyle.normalStyle(
              fontSize: ResponsiveHelper.fontExtraSmall,
            ),
            backgroundColor: AppColors.kSecondaryColor,
            selectedItemColor: AppColors.kPrimaryColor,
            unselectedItemColor: AppColors.kTextPrimaryColor,

            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(
              shadows: [
                Shadow(
                  color: AppColors.kWhite,
                  blurRadius: 1,
                  offset: Offset(1, 0),
                ),
              ],
              color: AppColors.kPrimaryColor,
            ),
            unselectedIconTheme: IconThemeData(
              applyTextScaling: true,

              color: AppColors.kTextPrimaryColor,
            ),
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(SolarIconsBold.home2),
                icon: Icon(SolarIconsOutline.home2),
                label: "Home",
              ),
              BottomNavigationBarItem(
                activeIcon: _buildBadge(Icon(SolarIconsBold.camera)),
                icon: _buildBadge(Icon(SolarIconsOutline.camera)),
                label: "Uploads",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(SolarIconsBold.postsCarouselVertical),
                icon: Icon(SolarIconsOutline.postsCarouselVertical),
                label: "Product",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(SolarIconsBold.user),
                icon: Icon(SolarIconsOutline.user),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(Widget child) {
    int? data = 0;
    try {
      data = ref.watch(dashboardControllerProvider).value?.imagePending;
    } catch (e) {
      data = 0;
    }
    return badges.Badge(
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
