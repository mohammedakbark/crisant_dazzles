import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardAppBar extends StatelessWidget {
  final String pageName;
  // final IconData icon;
  const DashboardAppBar({
    super.key,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            child: Container(
              height: 80,
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
                height: 80,
                alignment: Alignment.centerLeft,
                width: ResponsiveHelper.wp,
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
                child: Text(
                  pageName,
                  style: AppStyle.boldStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                )

                //  Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Row(
                //       children: [
                //         Container(
                //           padding: const EdgeInsets.all(12),
                //           decoration: BoxDecoration(
                //             color: AppColors.kPrimaryColor.withOpacity(0.2),
                //             shape: BoxShape.circle,
                //           ),
                //           child: Icon(
                //             icon,
                //             color: AppColors.kWhite,
                //             size: 24,
                //           ),
                //         ),
                //         AppSpacer(
                //           wp: .05,
                //         ),
                //         Text(
                //           pageName,
                //           style: AppStyle.boldStyle(
                //             fontSize: 22,
                //             color: Colors.white,
                //           ),
                //         )
                //       ],
                //     ),
                //   ],
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
