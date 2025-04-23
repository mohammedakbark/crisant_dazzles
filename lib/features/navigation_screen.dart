import 'package:dazzles/core/services/navigation_controller.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/home/presentation/home_page.dart';
import 'package:dazzles/features/product/presentation/products_page.dart';
import 'package:dazzles/features/profile/presentation/profile_page.dart';
import 'package:dazzles/features/upload/presentation/upload_picture_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:badges/badges.dart' as badges;

class NavigationScreen extends ConsumerWidget {
  NavigationScreen({super.key});
  final List<Widget> _pages = [
    HomePage(),
    UploadPicturePage(),
    ProductsPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context, ref) {
    int index = ref.read(navigationController.notifier).state;
    return Scaffold(
      appBar:
          index == 1 || index == 3
              ? null
              : AppBar(
                bottom: PreferredSize(
                  preferredSize: Size(
                    ResponsiveHelper.wp,
                    ResponsiveHelper.hp * .01,
                  ),
                  child: SizedBox(),
                ),
                automaticallyImplyLeading: false,
                title: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(radius: 30),
                  title: Text(
                    "Hi,Anand Jain",
                    style: AppStyle.largeStyle(
                      fontSize: ResponsiveHelper.fontMedium,
                      color: AppColors.kWhite,
                    ),
                  ),
                  subtitle: Text(
                    "Welcome back to Dazzles !",
                    style: AppStyle.smallStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.fontSmall,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  trailing: badges.Badge(
                    badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent),
                    badgeContent: Text(
                      "10",
                      style: AppStyle.mediumStyle(fontSize: 8),
                    ),
                    position: badges.BadgePosition.topEnd(end: -2, top: -8),
                    badgeAnimation: badges.BadgeAnimation.slide(
                      curve: Curves.fastOutSlowIn,
                      colorChangeAnimationCurve: Curves.easeInCubic,
                    ),
                    child: CircleAvatar(
                      child: Icon(
                        CupertinoIcons.bell_fill,
                        color: AppColors.kWhite,
                      ),
                    ),
                  ),
                ),
              ),
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
                activeIcon: Icon(SolarIconsBold.camera),
                icon: Icon(SolarIconsOutline.camera),
                label: "Upload Picture",
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
}
