import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class QuickActions extends StatelessWidget {
  QuickActions({super.key});
  final List<AppPermission> quickActionPermissions = [
    AppPermission.valet,
    AppPermission.purchaseOrderList,
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
              const Flexible(
                child: Divider(height: 0, color: AppColors.kGrey),
              ),
            ],
          ),
        AppSpacer(hp: .03),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: visibleQuickActions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final perm = visibleQuickActions[index];
            final color = perm.color;
            final icon = perm.icon;
            final title = perm.title;

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => perm.onTap(context),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2.5, color: color),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 28, color: color, semanticLabel: title),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppStyle.boldStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
