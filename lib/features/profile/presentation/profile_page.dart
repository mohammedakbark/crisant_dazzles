import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/local%20data/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/profile/data/models/user_profile_model.dart';
import 'package:dazzles/features/profile/presentation/widgets/profile_shimmer.dart';
import 'package:dazzles/features/profile/providers/get_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final profileController = ref.watch(profileControllerController);
    return AppMargin(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              AppSpacer(hp: .07),
              BuildStateManageComponent(
                controller: profileController,
                errorWidget: (p0, p1) => Text(p0.toString()),
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
                  onPressed: () async {
                    await LoginRefDataBase().clearLoginCredential();
                    if (context.mounted) {
                      context.go(initialScreen);
                    }
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
              AppSpacer(hp: .1),
            ],
          ),
        ),
      ),
    );
  }
}
