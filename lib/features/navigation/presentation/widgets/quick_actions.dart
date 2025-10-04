import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/paint/action_grid_item_paint.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/operation-or-task/presentation/widgets/action_grid_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class QuickActions extends StatelessWidget {
  QuickActions({super.key});
  final List<AppPermission> quickActionPermissions = [
    AppPermission.productlist,
    AppPermission.purchaseorderlist,
    AppPermission.valey,
    AppPermission.operationaction,
    AppPermission.scanproduct,
    AppPermission.updateproduct,
    AppPermission.recentlyupdated,
  ];
  @override
  Widget build(BuildContext context) {
    final permissionForUser = AppPermissionConfig().all.toList(growable: false);
    final visibleQuickActions = quickActionPermissions
        .where(
          (p) => permissionForUser.contains(p),
        )
        .toList();
    return Column(
      children: [
        if (quickActionPermissions.isNotEmpty)
          Row(
            children: [
              const Icon(SolarIconsBold.bolt, size: 16),
              const SizedBox(width: 8),
              Text("Quick Actions", style: AppStyle.boldStyle(fontSize: 16)),
              const SizedBox(width: 12),
              Flexible(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kGrey,
                        AppColors.kGrey.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        AppSpacer(hp: .03),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 50),
          itemCount: visibleQuickActions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.isTablet() ? 4 : 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final perm = visibleQuickActions[index];
            final color = perm.color;
            final icon = perm.icon;
            final title = perm.title;

            return ActionGridItemTile(
              color: color,
              icon: icon,
              title: title,
              onTap: () => perm.onTap(context),
            );
          },
        )
      ],
    );
  }
}
