import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/material.dart';

class OperationTaskViewScreen extends StatelessWidget {
  const OperationTaskViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: AppBarText(title: "Operations"),
        actions: [
          if (AppPermissionConfig().has(AppPermission.createoperationtask))
            TextButton(
                onPressed: () {},
                child: Text(
                  "Create Task",
                  style: AppStyle.mediumStyle(color: AppColors.kDeepPurple),
                ))
        ],
      ),
    );
  }
}
