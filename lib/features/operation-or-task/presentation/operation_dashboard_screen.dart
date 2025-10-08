import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/dashboard_app_bar.dart';
import 'package:dazzles/core/paint/action_grid_item_paint.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/operation-or-task/data/model/operation_dashboard_model.dart';
import 'package:dazzles/features/operation-or-task/data/provider/operation_dashboard_controller.dart';
import 'package:dazzles/features/operation-or-task/presentation/widgets/action_grid_item_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class OperationDashboardScreen extends ConsumerStatefulWidget {
  OperationDashboardScreen({super.key});

  @override
  ConsumerState<OperationDashboardScreen> createState() =>
      _OperationDashboardScreenState();
}

class _OperationDashboardScreenState
    extends ConsumerState<OperationDashboardScreen> {
  List<AppPermission> operationActions = [
    AppPermission.createoperationtask,
    AppPermission.myoperationtasklist,
    AppPermission.todooperationtasklist,
    AppPermission.operationrequestlist
  ];
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        ref.invalidate(operationDashboardControllerProvider);
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final operationDashboardController =
        ref.watch(operationDashboardControllerProvider);
    final permissionForUser = AppPermissionConfig().all.toList(growable: false);
    final visibleQuickActions = operationActions
        .where(
          (p) => permissionForUser.contains(p),
        )
        .toList();
    return Scaffold(
        body: AppMargin(
            child: SafeArea(
      child: Column(
        children: [
          AppSpacer(hp: .03),
          DashboardAppBar(
            pageName: "Operation Dashboard",
          ),
          if (AppPermissionConfig().has(AppPermission.operationdashboard)) ...[
            BuildStateManageComponent(
              stateController: operationDashboardController,
              successWidget: (data) {
                final dashboardData = data as OperationDashboardModel;

                return Column(
                  children: [
                    AppSpacer(hp: .03),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.kPrimaryColor.withOpacity(0.2),
                                AppColors.kPrimaryColor.withOpacity(0.05),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(SolarIconsBold.shop, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text("Store Insight",
                            style: AppStyle.boldStyle(fontSize: 16)),
                        const SizedBox(width: 12),
                      ],
                    ),
                    AppSpacer(hp: .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.kPrimaryColor.withOpacity(0.1),
                                AppColors.kPrimaryColor.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                                width: 2,
                                color:
                                    AppColors.kPrimaryColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.kPrimaryColor.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.kPrimaryColor,
                                  size: 20,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                dashboardData.completedCount.toString(),
                                style: AppStyle.boldStyle(fontSize: 32),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Completed Task",
                                style: AppStyle.boldStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )),
                        SizedBox(width: 12),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.withOpacity(0.1),
                                Colors.orange.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                                width: 2),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.pending_actions_rounded,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                dashboardData.pendingCount.toString(),
                                style: AppStyle.boldStyle(fontSize: 32),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Pending Task",
                                style: AppStyle.boldStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                    AppSpacer(hp: .02),
                  ],
                );
              },
            ),
          ],
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kPrimaryColor.withOpacity(0.2),
                      AppColors.kPrimaryColor.withOpacity(0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(SolarIconsBold.addCircle, size: 16),
              ),
              const SizedBox(width: 8),
              Text("Operation Actions",
                  style: AppStyle.boldStyle(fontSize: 16)),
              const SizedBox(width: 12),
            ],
          ),
          AppSpacer(hp: .02),
          Expanded(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: visibleQuickActions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
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
                }),
          ),
        ],
      ),
    )));
  }
}

// Custom painter for grid items with decorative elements

// Custom painter for stats cards with decorative patterns
// class StatsCardPainter extends CustomPainter {
//   final Color color;

//   StatsCardPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color.withOpacity(0.08)
//       ..style = PaintingStyle.fill;

//     // Draw decorative dots pattern
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 2; j++) {
//         canvas.drawCircle(
//           Offset(size.width - 15 - (i * 8), 15 + (j * 8)),
//           2,
//           paint,
//         );
//       }
//     }

//     // Draw decorative wave at bottom
//     final wavePaint = Paint()
//       ..color = color.withOpacity(0.05)
//       ..style = PaintingStyle.fill;

//     final path = Path()
//       ..moveTo(0, size.height - 20)
//       ..quadraticBezierTo(
//         size.width * 0.25,
//         size.height - 30,
//         size.width * 0.5,
//         size.height - 20,
//       )
//       ..quadraticBezierTo(
//         size.width * 0.75,
//         size.height - 10,
//         size.width,
//         size.height - 20,
//       )
//       ..lineTo(size.width, size.height)
//       ..lineTo(0, size.height)
//       ..close();

//     canvas.drawPath(path, wavePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
