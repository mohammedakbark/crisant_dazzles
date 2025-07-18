import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/driver/home/data/provider/home%20provider/driver_home_controller.dart';
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

class _DriverHomeState extends ConsumerState<DriverHome>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        ref.invalidate(qrCodeRedControllerProvider);
      },
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: AppMargin(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppSpacer(hp: .03),
                  _buildEnhancedButtonTile(
                    "Check In",
                    CupertinoIcons.arrow_down_circle_fill,
                    Colors.green,
                    () {
                      context.push(drQrScannerScreen,
                          extra: {"scanFor": "checkIn"});
                    },
                  ),
                  AppSpacer(
                    hp: .025,
                  ),
                  // Check Out Button
                  _buildEnhancedButtonTile(
                    "Check Out",
                    CupertinoIcons.arrow_up_circle_fill,
                    Colors.red,
                    () async {
                      context.push(drQrScannerScreen,
                          extra: {"scanFor": "checkOut"});
                    },
                  ),

                  AppSpacer(hp: .03),

                  ref.watch(qrCodeRedControllerProvider).when(
                        loading: () => AppLoading(),
                        error: (error, stackTrace) =>
                            AppErrorView(error: error.toString()),
                        data: (data) {
                          if (data == null) return SizedBox.shrink();
                          return Column(
                            children: [
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Today Insight",
                                    style: AppStyle.boldStyle(),
                                  )),
                              AppSpacer(hp: .02),

                              // Quick Stats Row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      'Check In',
                                      data.totalCheckIn.toString(),
                                      SolarIconsOutline.arrowDown,
                                      Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      'Check Out',
                                      data.totalCheckOut.toString(),
                                      SolarIconsOutline.arrowUp,
                                      Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                  AppSpacer(hp: .03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedButtonTile(
    String title,
    IconData icon,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      height: ResponsiveHelper.hp * .23,
      duration: const Duration(milliseconds: 200),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadiusLarge),
        shadowColor: accentColor.withAlpha(80),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(ResponsiveHelper.borderRadiusLarge),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: ResponsiveHelper.wp,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(ResponsiveHelper.borderRadiusLarge),
              gradient: LinearGradient(
                colors: [
                  accentColor.withAlpha(80),
                  accentColor.withAlpha(10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // color: isEnabled ? null : Colors.grey.shade100,
              border: Border.all(
                color: accentColor.withAlpha(80),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.2)),
                    child: Icon(icon, size: 36, color: accentColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: AppStyle.boldStyle(
                      fontSize: 18,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (title.contains('In') ? 'Park new car' : 'Deliver car'),
                    style: AppStyle.mediumStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      height: ResponsiveHelper.hp * .1,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: AppStyle.boldStyle(
                  fontSize: 18,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppStyle.mediumStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
