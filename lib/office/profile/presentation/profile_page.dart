import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/services/navigation_controller.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/office/notification/data/providers/notification_controller.dart';
import 'package:dazzles/office/profile/data/models/user_profile_model.dart';
import 'package:dazzles/office/profile/presentation/widgets/profile_shimmer.dart';
import 'package:dazzles/office/profile/data/providers/get_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final profileController = ref.watch(profileControllerProvider);
    return AppMargin(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              AppSpacer(hp: .07),
              BuildStateManageComponent(
                stateController: profileController,
                errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
                loadingWidget: () => ProfileShimmer(),
                successWidget: (data) {
                  final datas = data as UserProfileModel;
                  return Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            child: Text(
                              datas.username[0].toUpperCase(),
                              style: AppStyle.largeStyle(
                                fontSize: ResponsiveHelper.fontXLarge,
                              ),
                            ),
                          ),
                          AppSpacer(wp: .05),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  datas.username.replaceFirst(
                                    datas.username[0],
                                    datas.username[0].toUpperCase(),
                                  ),
                                  style: AppStyle.largeStyle(
                                    fontSize: ResponsiveHelper.fontLarge,
                                  ),
                                ),
                                Text(
                                  datas.role.toUpperCase(),
                                  style: AppStyle.largeStyle(
                                    color: AppColors.kPrimaryColor,
                                    fontSize: ResponsiveHelper.fontSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSpacer(hp: .05),
                      Text(
                        datas.store,
                        style: AppStyle.largeStyle(
                          color: AppColors.kWhite,
                          fontSize: ResponsiveHelper.fontLarge,
                        ),
                      ),
                    ],
                  );
                },
              ),
              AppSpacer(hp: .05),
              SizedBox(
                width: ResponsiveHelper.wp * .5,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.kErrorPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => showLogoutConfirmation(context, ref),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        SolarIconsOutline.logout,
                        color: AppColors.kErrorPrimary,
                      ),
                      AppSpacer(wp: .02),
                      Text(
                        "Logout",
                        style: AppStyle.mediumStyle(
                          color: AppColors.kErrorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacer(hp: .1),
            ],
          ),
        ),
      ),
    );
  }

  static void showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AnimatedPadding(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SlideInUp(
            duration: Duration(milliseconds: 400),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are You Sure?',
                    style: AppStyle.mediumStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ZoomIn(
                          duration: Duration(milliseconds: 600),
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.kWhite,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => context.pop(),
                            icon: Icon(Icons.close, color: AppColors.kWhite),
                            label: Text("Cancel"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ZoomIn(
                          duration: Duration(milliseconds: 800),
                          child: SizedBox(
                            width: ResponsiveHelper.wp * .5,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side:
                                    BorderSide(color: AppColors.kErrorPrimary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await LoginRefDataBase().clearLoginCredential();
                                await FirebasePushNotification().deleteToken();
                                ref.read(navigationController.notifier).state =
                                    0;
                                if (context.mounted) {
                                  context.go(initialScreen);
                                }

                                // logout
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    SolarIconsOutline.logout,
                                    color: AppColors.kErrorPrimary,
                                  ),
                                  AppSpacer(wp: .02),
                                  Text(
                                    "Logout",
                                    style: AppStyle.mediumStyle(
                                      color: AppColors.kErrorPrimary,
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
        );
      },
    );
  }

  static Future<void> logout(BuildContext context) async {
    await LoginRefDataBase().clearLoginCredential();
    final ref = ProviderContainer();
    ref.read(navigationController.notifier).state = 0;
    if (context.mounted) {
      context.go(initialScreen);
    }
  }
}
