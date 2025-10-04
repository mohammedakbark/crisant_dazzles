// lib/ui/navigation_screen.dart

import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/features/navigation/data/provider/dashboard_controller.dart';
import 'package:dazzles/features/navigation/presentation/widgets/dashboard_grid.dart';
import 'package:dazzles/features/navigation/presentation/widgets/quick_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationScreen extends ConsumerWidget {
  NavigationScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return AppMargin(
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          if (AppPermissionConfig().has(AppPermission.dashboardinsight)) {
            return ref.refresh(dashboardControllerProvider);
          }
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacer(hp: .02),
              if (AppPermissionConfig()
                  .has(AppPermission.dashboardinsight)) ...[
                DashboardGrid(), // DASHBOARD GRID WTH COUNT
                AppSpacer(
                  hp: .02,
                )
              ],

              QuickActions() // QUICK ACTION GRID
            ],
          ),
        ),
      ),
    );
  }
}
