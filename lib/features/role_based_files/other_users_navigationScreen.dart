import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/profile/data/models/user_profile_model.dart';
import 'package:dazzles/features/profile/data/providers/get_profile_controller.dart';
import 'package:dazzles/features/profile/presentation/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

class OtherUsersNaviagationScreen extends ConsumerWidget {
  const OtherUsersNaviagationScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final profileController = ref.watch(profileControllerProvider);
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                alignment: Alignment.center,
                color: AppColors.kPrimaryColor,
                width: ResponsiveHelper.wp,
                height: ResponsiveHelper.hp * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "DAZZLES",
                      style: GoogleFonts.roboto(
                        fontSize: ResponsiveHelper.wp * .15,
                        fontWeight: FontWeight.w100,
                        color: AppColors.kBgColor,
                      ),
                    ),
                    Text(
                      "MYSORE | BANGALORE",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w100,
                          color: AppColors.kBgColor,
                          fontSize: ResponsiveHelper.wp * .04,
                          letterSpacing: 3,
                          height: -.2),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: -60,
                  child: BuildStateManageComponent(
                    stateController: profileController,
                    errorWidget: (p0, p1) => SizedBox(),
                    loadingWidget: () => SizedBox(),
                    successWidget: (data) {
                      final userProfileModel = data as UserProfileModel;
                      return Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        width: ResponsiveHelper.wp * .5,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.kWhite, width: 2),
                            shape: BoxShape.circle,
                            color: AppColors.kBgColor),
                        child: Text(
                          userProfileModel.username[0].toUpperCase(),
                          style: AppStyle.largeStyle(fontSize: 70),
                        ),
                      );
                    },
                  )),
            ],
          ),
          Expanded(
            child: BuildStateManageComponent(
              stateController: profileController,
              errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
              successWidget: (data) {
                final userProfileModel = data as UserProfileModel;
                return Column(children: [
                  AppMargin(
                    child: Column(
                      children: [
                        AppSpacer(
                          hp: .1,
                        ),
                        Container(
                            padding: EdgeInsets.all(15),
                            width: ResponsiveHelper.wp,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    AppColors.kTextPrimaryColor.withAlpha(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTile(
                                    "User Name", userProfileModel.username),
                                _buildDevider(),
                                _buildTile("Store", userProfileModel.store),
                                _buildDevider(),
                                _buildTile("Role", userProfileModel.role)
                              ],
                            )),
                        AppSpacer(
                          hp: .05,
                        ),
                        _buildButton(
                          "Notification",
                          CupertinoIcons.arrow_right_circle,
                          () {
                            context.push(notificationScreen);
                          },
                        ),
                      ],
                    ),
                  )
                ]);
              },
            ),
          ),
          AppSpacer(
            hp: .1,
          ),
          SizedBox(
            width: ResponsiveHelper.wp * .5,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.kErrorPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => ProfilePage.showLogoutConfirmation(context, ref),
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
          AppSpacer(
            hp: .1,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String title, IconData icon, void Function()? onTap) =>
      InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),

        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: AppColors.kWhite),
          width: ResponsiveHelper.wp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.bell,
                    color: AppColors.kBgColor,
                  ),
                  AppSpacer(
                    wp: .02,
                  ),
                  Text(
                    title,
                    style: AppStyle.boldStyle(color: AppColors.kBgColor),
                  )
                ],
              ),
              Icon(
                icon,
                color: AppColors.kBgColor,
              )
            ],
          ),
        ),
      );

  Widget _buildDevider() => Divider(
        color: AppColors.kBgColor,
        thickness: 2,
      );

  Widget _buildTile(String title, String data) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.wp * .25,
            child: Text(
              "${title}",
              style: AppStyle.mediumStyle(fontSize: 15),
            ),
          ),
          Text(
            ":  ",
            style: AppStyle.mediumStyle(fontSize: 15),
          ),
          Flexible(
            child: Text(
              "${data}",
              style: AppStyle.boldStyle(fontSize: 15),
            ),
          )
        ],
      );
}
