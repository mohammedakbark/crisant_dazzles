import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/services/office_navigation_controller.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/notification/data/providers/notification_controller.dart';
import 'package:dazzles/module/office/profile/data/models/user_profile_model.dart';
import 'package:dazzles/module/office/profile/data/providers/get_profile_controller.dart';
import 'package:dazzles/module/office/profile/presentation/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

// Enhanced Shimmer Component

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final profileController = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.02),
            ],
          ),
        ),
        child: AppMargin(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  AppSpacer(hp: .03),

                  // Header with subtle animation
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Profile',
                        style: AppStyle.largeStyle(
                          fontSize: ResponsiveHelper.fontXLarge,
                          fontWeight: FontWeight.w300,
                          color: AppColors.kWhite.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),

                  AppSpacer(hp: .04),

                  // Enhanced Profile Card
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: BuildStateManageComponent(
                        stateController: profileController,
                        errorWidget: (p0, p1) =>
                            AppErrorView(error: p0.toString()),
                        loadingWidget: () => const AnimatedProfileShimmer(),
                        successWidget: (data) {
                          final datas = data as UserProfileModel;
                          return _buildProfileContent(datas);
                        },
                      ),
                    ),
                  ),

                  AppSpacer(hp: .06),

                  // Enhanced Action Buttons
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Column(
                      children: [
                        buildActionButton(
                          icon: SolarIconsOutline.logout,
                          label: 'Logout',
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            showLogoutConfirmation(context, ref);
                          },
                          isPrimary: false,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),

                  AppSpacer(hp: .05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserProfileModel datas) {
    return Column(
      children: [
        // Avatar with enhanced design
        Stack(
          children: [
            Container(
             
              width: ResponsiveHelper.wp*.7,
              height: ResponsiveHelper.hp*.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.kPrimaryColor.withOpacity(0.8),
                    AppColors.kPrimaryColor.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: ResponsiveHelper.isTablet() ? 100 : 60,
                backgroundColor: Colors.transparent,
                child: Text(
                  datas.username[0].toUpperCase(),
                  style: AppStyle.largeStyle(
                    fontSize: ResponsiveHelper.fontXLarge * 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Online status indicator
            // Positioned(
            //   bottom: 8,
            //   right: 8,
            //   child: Container(
            //     width: 20,
            //     height: 20,
            //     decoration: BoxDecoration(
            //       color: Colors.green,
            //       shape: BoxShape.circle,
            //       border: Border.all(color: Colors.white, width: 3),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.green.withOpacity(0.3),
            //           blurRadius: 8,
            //           spreadRadius: 2,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),

        AppSpacer(hp: .03),

        // User Info with better typography
        Column(
          children: [
            Text(
              datas.username.replaceFirst(
                datas.username[0],
                datas.username[0].toUpperCase(),
              ),
              style: AppStyle.largeStyle(
                fontSize: ResponsiveHelper.fontXLarge,
                fontWeight: FontWeight.w600,
                color: AppColors.kWhite,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacer(hp: .01),

            // Role Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.kPrimaryColor.withOpacity(0.2),
                    AppColors.kPrimaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.kPrimaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                datas.role.toUpperCase(),
                style: AppStyle.mediumStyle(
                  color: AppColors.kPrimaryColor,
                  fontSize: ResponsiveHelper.fontSmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            AppSpacer(hp: .03),

            // Store Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    SolarIconsOutline.shop,
                    color: AppColors.kWhite.withOpacity(0.7),
                    size: ResponsiveHelper.isTablet() ? 40 : 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    datas.store,
                    style: AppStyle.mediumStyle(
                      color: AppColors.kWhite.withOpacity(0.9),
                      fontSize: ResponsiveHelper.fontMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.kErrorPrimary
        : isPrimary
            ? AppColors.kPrimaryColor
            : AppColors.kWhite.withOpacity(0.8);

    return Container(
      
      width: ResponsiveHelper.wp * .75,
      height: ResponsiveHelper.hp * .06,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withOpacity(0.6), width: 1.5),
          backgroundColor: color.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: ResponsiveHelper.isTablet() ? 40 : 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppStyle.mediumStyle(
                color: color,
                fontSize: ResponsiveHelper.fontSmall,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    HapticFeedback.mediumImpact();
    final isTab = ResponsiveHelper.isTablet();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SlideInUp(
            duration: const Duration(milliseconds: 400),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[900]!.withOpacity(0.95),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Warning Icon
                    FadeIn(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        width:isTab?120: 80,
                        height:isTab?120: 80,
                        decoration: BoxDecoration(
                          color: AppColors.kErrorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.kErrorPrimary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          SolarIconsOutline.dangerTriangle,
                          color: AppColors.kErrorPrimary,
                          size:isTab?55: 36,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      child: Text(
                        'Confirm Logout',
                        style: AppStyle.largeStyle(
                          fontSize:isTab?40: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Description
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        'Are you sure you want to logout?\nYou will need to sign in again.',
                        style: AppStyle.mediumStyle(
                          color: Colors.white.withOpacity(0.7),
                         fontSize:isTab?20: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: SlideInLeft(
                            duration: const Duration(milliseconds: 600),
                            child: Container(
                              height: 52,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                  foregroundColor: AppColors.kWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  context.pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: AppStyle.mediumStyle(
                                    fontSize: isTab?20:null,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Logout Button
                        Expanded(
                          child: SlideInRight(
                            duration: const Duration(milliseconds: 600),
                            child: Container(
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.kErrorPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();

                                  // Show loading state
                                  Navigator.of(context).pop();

                                  // Perform logout
                                  await LoginRefDataBase()
                                      .clearLoginCredential();
                                  await FirebasePushNotification()
                                      .deleteToken();
                                  ref
                                      .read(officeNavigationController.notifier)
                                      .state = 0;

                                  if (context.mounted) {
                                    context.go(initialScreen);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      SolarIconsOutline.logout,
                                      size:isTab?30: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Logout",
                                      style: AppStyle.mediumStyle(
                                         fontSize: isTab?20:null,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> logout(BuildContext context) async {
    await LoginRefDataBase().clearLoginCredential();
    final ref = ProviderContainer();
    ref.read(officeNavigationController.notifier).state = 0;
    if (context.mounted) {
      context.go(initialScreen);
    }
  }
}
