import 'dart:developer';

import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/office/profile/presentation/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

class OtherUsersNaviagationScreen extends ConsumerWidget {
  const OtherUsersNaviagationScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
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
                child: FutureBuilder(
                    future: LoginRefDataBase().getUserData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AppLoading();
                      }
                      final userModel = snapshot.data;
                      return userModel == null
                          ? SizedBox()
                          : Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              width: ResponsiveHelper.wp * .5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.kWhite, width: 2),
                                  shape: BoxShape.circle,
                                  color: AppColors.kBgColor),
                              child: Text(
                                userModel.userName![0].toUpperCase(),
                                style: AppStyle.largeStyle(fontSize: 70),
                              ),
                            );
                    }),
              ),
              // Positioned(
              //     bottom: -60,
              //     child: BuildStateManageComponent(
              //       stateController: profileController,
              //       errorWidget: (p0, p1) => SizedBox(),
              //       loadingWidget: () => SizedBox(),
              //       successWidget: (data) {
              //         final userProfileModel = data as UserProfileModel;
              //         return
              //       },
              //     )),
            ],
          ),
          Expanded(
              child: FutureBuilder(
                  future: LoginRefDataBase().getUserData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppLoading();
                    }
                    final userModel = snapshot.data;
                    return userModel == null
                        ? SizedBox()
                        : Column(children: [
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: AppColors.kTextPrimaryColor
                                              .withAlpha(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildTile("User Name",
                                              userModel.userName ?? 'N/A'),
                                          _buildDevider(),
                                          // _buildTile(
                                          //     "Store", userModel.store),
                                          // _buildDevider(),
                                          _buildTile(
                                              "Role", userModel.role ?? 'N/A')
                                        ],
                                      )),
                                  AppSpacer(
                                    hp: .05,
                                  ),
                                  _buildButton(
                                    "Notification",
                                    CupertinoIcons.arrow_right_circle,
                                    () {
                                      log(userModel.pushToken ?? '');
                                      context.push(notificationScreen);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]);
                  })),
          AppSpacer(
            hp: .1,
          ),
          ProfilePage.buildActionButton(
            icon: SolarIconsOutline.logout,
            label: 'Logout',
            onPressed: () {
              HapticFeedback.mediumImpact();
              ProfilePage.showLogoutConfirmation(context, ref);
            },
            isPrimary: false,
            isDestructive: true,
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
