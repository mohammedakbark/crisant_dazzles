import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/permission_hendle.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/office/auth/data/providers/login_controller.dart';
import 'package:dazzles/office/notification/data/providers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await AppPermissions.handleCameraPermission();
  }

  void goNext() async {
    final loginRef = await LoginRefDataBase().getUserData;
    if (loginRef.token != null && loginRef.token!.isNotEmpty) {
      log("User Role -> ${loginRef.role}");

      if (mounted) {
        if (loginRef.role == LoginController.mainRole) {
          context.go(route);
        } else {
          await FirebasePushNotification().initNotification(context);
          context.go(driverNavScreen);
        }
      }
    } else {
      if (mounted) {
        context.go(loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTab = ResponsiveHelper.isTablet();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            AppSpacer(
              hp: .05,
            ),
            SizedBox(
              height: ResponsiveHelper.hp * .1,
              width: ResponsiveHelper.wp,
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    letterSpacing: -3,
                    fontSize: isTab ? 120 : 60,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w100,
                  ),

                  // GoogleFonts.hachiMaruPop(
                  //   fontSize: 59,
                  //   color: AppColors.kPrimaryColor,
                  //   fontWeight: FontWeight.w100,
                  // ),
                  child: AnimatedTextKit(
                    onFinished: goNext,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText(
                        'नमस्ते',
                        speed: Duration(microseconds: 100000),
                      ),
                      TyperAnimatedText(
                        'hello',
                        speed: Duration(microseconds: 100000),
                      ),
                      TyperAnimatedText(
                        'ನಮಸ್ಕಾರ',
                        speed: Duration(microseconds: 100000),
                      ),
                      TyperAnimatedText(
                        'வணக்கம்',
                        speed: Duration(microseconds: 100000),
                      ),
                      TyperAnimatedText(
                        'నమస్తే',
                        speed: Duration(microseconds: 100000),
                      ),
                      TyperAnimatedText(
                        'നമസ്കാരം',
                        speed: Duration(microseconds: 100000),
                      ),
                      TyperAnimatedText(
                        'السلام علیکم',
                        speed: Duration(microseconds: 100000),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacer(
              hp: .05,
            ),
            InkWell(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              onTap: goNext,
              child: Text(
                "Skip",
                style: AppStyle.normalStyle(
                    fontSize: isTab ? 40 : 20, color: AppColors.kPrimaryColor),
              ),
            ),
            Spacer(),
            FutureBuilder(
              future: getAppVersion(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.done
                      ? Text(
                          snapshot.data ?? 'null',
                          style: AppStyle.normalStyle(),
                        )
                      : SizedBox(),
            ),
            AppSpacer(
              hp: .05,
            )
          ],
        ),
      ),
    );
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    log(info.appName);
    return 'App Version ${info.version}';
  }
}
