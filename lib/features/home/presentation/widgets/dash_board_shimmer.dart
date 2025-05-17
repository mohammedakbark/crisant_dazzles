import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/shimmer_effect.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class DashBoardShimmer extends StatelessWidget {
  const DashBoardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        children: [
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              crossAxisCount: 2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => _buildGridTile(),
          ),
            AppSpacer(hp: .015),
          // Products
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recently Captured", style: AppStyle.largeStyle()),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: AppStyle.largeStyle(
                    color: AppColors.kPrimaryColor,
                    fontSize: ResponsiveHelper.fontSmall,
                  ),
                ),
              ),
            ],
          ),
          AppSpacer(hp: .01),
          // product Grid
          Container(
            color: AppColors.kBorderColor,
            width: ResponsiveHelper.wp,
            height: ResponsiveHelper.hp*.2,
          )
        ],
      ),
    );
  }

  Widget _buildGridTile() => Container(
    decoration: BoxDecoration(
    color: AppColors.kBorderColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.kPrimaryColor.withAlpha(30),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
    ),
  );
}
