// lib/ui/navigation_screen.dart

import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/navigation/presentation/widgets/dashboard_grid.dart';
import 'package:dazzles/features/navigation/presentation/widgets/quick_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMargin(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacer(hp: .02),
            if (AppPermissionConfig().has(AppPermission.productDashboard)) ...[
              DashboardGrid(), // DASHBOARD GRID WTH COUNT
              AppSpacer(
                hp: .02,
              )
            ],

            QuickActions() // QUICK ACTION GRID
          ],
        ),
      ),
    );
  }
}
