import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/custom_app_bar.dart';
import 'package:flutter/material.dart';

class OperationDashboardScreen extends StatelessWidget {
  OperationDashboardScreen({super.key});
  List<AppPermission> operationActions = [
    AppPermission.createoperationtask,
    AppPermission.myoperationtasklist,
    AppPermission.todooperationtasklist,
    AppPermission.operationrequestlist
  ];
  @override
  Widget build(BuildContext context) {
    final permissionForUser = AppPermissionConfig().all.toList(growable: false);
    final visibleQuickActions = operationActions
        .where(
          (p) => permissionForUser.contains(p),
        )
        .toList();
    return Scaffold(
        appBar: AppBar(
          leading: AppBackButton(),
          title: AppBarText(title: "Operation Dashboard"),
        ),
        body: AppMargin(
          child: GridView.builder(
              itemCount: operationActions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                final perm = visibleQuickActions[index];
                final color = perm.color;
                final icon = perm.icon;
                final title = perm.title;
                return Material(
                  color: color.withAlpha(300),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: color, width: 2.5),
                      borderRadius: BorderRadiusGeometry.circular(20)),
                  child: InkWell(
                    onTap: () => perm.onTap(context),
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 28, semanticLabel: title),
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
              }),
        ));
  }
}
