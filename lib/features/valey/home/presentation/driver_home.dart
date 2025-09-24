import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/valey/home/data/provider/home%20provider/driver_home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class DriverHome extends ConsumerStatefulWidget {
  const DriverHome({super.key});

  @override
  ConsumerState<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends ConsumerState<DriverHome> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        ref.invalidate(qrCodeRedControllerProvider);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: ResponsiveHelper.hp,
          child: SafeArea(
            child: AppMargin(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  return await ref.refresh(qrCodeRedControllerProvider);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacer(hp: .03),
                    _buildWelcomeSection(),
                    AppSpacer(hp: .04),
                    _buildActionButtons(),
                    AppSpacer(hp: .04),
                    _buildInsightsSection(),
                    AppSpacer(hp: .03),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.kPrimaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.kPrimaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(CupertinoIcons.square_grid_2x2_fill),
            ),
          ),
          AppSpacer(
            wp: .02,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.kPrimaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.kPrimaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_parking_rounded,
                          color: AppColors.kWhite,
                          size: 24,
                        ),
                      ),
                      AppSpacer(
                        wp: .05,
                      ),
                      Text(
                        "Valey",
                        style: AppStyle.boldStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    return ref.watch(qrCodeRedControllerProvider).when(
          loading: () => Container(
            height: 120,
            child: Center(child: AppLoading()),
          ),
          error: (error, stackTrace) => AppErrorView(error: error.toString()),
          data: (data) {
            if (data == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 16),
                  child: Row(
                    children: [
                      Icon(
                        SolarIconsOutline.chartSquare,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Today's Insights",
                        style: AppStyle.boldStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildEnhancedStatCard(
                        'Check In',
                        data.totalCheckIn.toString(),
                        SolarIconsOutline.arrowDown,
                        const Color(0xFF6366f1),
                        const Color(0xFF8b5cf6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildEnhancedStatCard(
                        'Check Out',
                        data.totalCheckOut.toString(),
                        SolarIconsOutline.arrowUp,
                        const Color(0xFF06b6d4),
                        const Color(0xFF3b82f6),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 20),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.qrcode,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Quick Actions",
                style: AppStyle.boldStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedButtonTile(
                "Check In",
                CupertinoIcons.arrow_down_circle_fill,
                const LinearGradient(
                  colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                () {
                  context
                      .push(drQrScannerScreen, extra: {"scanFor": "checkIn"});
                  // context.push(drCustomerRegScreen, extra: {"qrId": "6"});
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEnhancedButtonTile(
                "Check Out",
                CupertinoIcons.arrow_up_circle_fill,
                const LinearGradient(
                  colors: [Color(0xFF06b6d4), Color(0xFF3b82f6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                () async {
                  context
                      .push(drQrScannerScreen, extra: {"scanFor": "checkOut"});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedButtonTile(
    String title,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return Container(
      height: ResponsiveHelper.hp * .25,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Glassmorphism effect
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: AppStyle.boldStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        textAlign: TextAlign.center,
                        title.contains('In')
                            ? 'Start parking – assign QR & capture car condition.'
                            : 'Complete delivery by locating, verifying, and recording the vehicle.',
                        style: AppStyle.smallStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    String title,
    String value,
    IconData icon,
    Color startColor,
    Color endColor,
  ) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: ResponsiveHelper.hp * .12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            startColor.withOpacity(0.1),
            endColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: startColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: startColor.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: startColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: startColor,
                        size: 16,
                      ),
                    ),
                    Text(
                      value,
                      style: AppStyle.boldStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  title,
                  style: AppStyle.mediumStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
