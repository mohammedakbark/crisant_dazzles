import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/shimmer_effect.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 70),
              AppSpacer(wp: .05),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerEffect.placeHolder(
                      height: 12,
                      width: ResponsiveHelper.wp * .23,
                    ),
                    AppSpacer(hp: .01),
                   ShimmerEffect.placeHolder(
                      height: 7,
                      width: ResponsiveHelper.wp * .45,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacer(hp: .05),
          ShimmerEffect.placeHolder(
            height: 10,
            width: ResponsiveHelper.wp * .7,
          ),
        ],
      ),
    );
  }
}
