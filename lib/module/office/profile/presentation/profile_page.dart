import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfilePageNew extends ConsumerStatefulWidget {
  const ProfilePageNew({super.key});

  @override
  ConsumerState<ProfilePageNew> createState() => _ProfilePageState();

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
                        width: isTab ? 120 : 80,
                        height: isTab ? 120 : 80,
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
                          size: isTab ? 55 : 36,
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
                          fontSize: isTab ? 40 : 24,
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
                          fontSize: isTab ? 20 : 16,
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
                                    fontSize: isTab ? 20 : null,
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
                                      size: isTab ? 30 : 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Logout",
                                      style: AppStyle.mediumStyle(
                                        fontSize: isTab ? 20 : null,
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

class _ProfilePageState extends ConsumerState<ProfilePageNew>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _profilePulseController;
  late Animation<double> _profilePulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _profilePulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _profilePulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profilePulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _profilePulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = ref.watch(profileControllerProvider);

    return Container(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderSection(),
                BuildStateManageComponent(
                  stateController: profileController,
                  errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
                  loadingWidget: () => const AnimatedProfileShimmer(),
                  successWidget: (data) {
                    final datas = data as UserProfileModel;
                    return _buildProfileContent(datas);
                  },
                ),
                AppSpacer(
                  hp: .04,
                ),
                _buildLogoutSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Header background with gradient
        Container(
          alignment: Alignment.center,
          width: ResponsiveHelper.wp,
          height: ResponsiveHelper.hp * .35,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.kPrimaryColor,
                const Color(0xFFE5B9B5),
                const Color.fromARGB(255, 247, 230, 230)
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Company info
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "DAZZLES",
                      style: GoogleFonts.roboto(
                        fontSize: ResponsiveHelper.wp * .12,
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "MYSORE | BANGALORE",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: ResponsiveHelper.wp * .035,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Profile avatar
        Positioned(
          bottom: -70,
          child: FutureBuilder(
            future: LoginRefDataBase().getUserData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: const Center(child: AppLoading()),
                );
              }
              final userModel = snapshot.data;
              return userModel == null
                  ? const SizedBox()
                  : AnimatedBuilder(
                      animation: _profilePulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _profilePulseAnimation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  // AppColors.kPrimaryColor,
                                  // const Color(0xFF6366f1),
                                  AppColors.kPrimaryColor,
                                  const Color.fromARGB(255, 251, 233, 233)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: AppColors.kPrimaryColor.withOpacity(0.4),
                              //     blurRadius: 20,
                              //     offset: const Offset(0, 10),
                              //   ),
                              // ],
                            ),
                            child: Center(
                              child: Text(
                                userModel.userName![0].toUpperCase(),
                                style: AppStyle.largeStyle(
                                  fontSize: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent(UserProfileModel userModel) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AppMargin(
        child: Column(
          children: [
            AppSpacer(hp: .12),
            _buildProfileInfoCard(userModel),
            // AppSpacer(hp: .04),
            // _buildNotificationButton(userModel),
            // AppSpacer(hp: .03),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(UserProfileModel userModel) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: ResponsiveHelper.wp,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kPrimaryColor.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      color: AppColors.kPrimaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Profile Information",
                      style: AppStyle.boldStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildEnhancedTile("User Name", userModel.username ?? 'N/A'),
                _buildEnhancedDivider(),
                _buildEnhancedTile("Role", userModel.role ?? 'N/A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(UserProfileModel userModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // log(userModel.pushToken ?? '');
            context.push(notificationScreen);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    CupertinoIcons.bell_fill,
                    color: AppColors.kPrimaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Notifications",
                    style: AppStyle.boldStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.arrow_right,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return AppMargin(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFef4444),
              Color(0xFFdc2626),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFef4444).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              ProfilePageNew.showLogoutConfirmation(context, ref);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.logout,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Logout",
                    style: AppStyle.boldStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTile(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.wp * .25,
            child: Text(
              title,
              style: AppStyle.mediumStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            ": ",
            style: AppStyle.mediumStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: AppStyle.boldStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
