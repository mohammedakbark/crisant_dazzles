import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMargin(
      child: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppSpacer(hp: .07),
              CircleAvatar(radius: 100),
              AppSpacer(hp: .05),
              Text(
                "Anand Jain",
                style: AppStyle.largeStyle(
                  fontSize: ResponsiveHelper.fontLarge,
                ),
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
                  onPressed: () {},
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
