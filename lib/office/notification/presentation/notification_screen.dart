import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/office/notification/data/models/notification_model.dart';
import 'package:dazzles/office/notification/data/providers/notification_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    Future.microtask(
      () {
        ref.invalidate(notificationListControllerProvider);
      },
    );
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Notifications", style: AppStyle.boldStyle()),
      ),
      body: RefreshIndicator.adaptive(
          onRefresh: () async {
            return ref.refresh(notificationListControllerProvider);
          },
          child: BuildStateManageComponent(
            stateController: ref.watch(notificationListControllerProvider),
            errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
            successWidget: (data) {
              final list = data as List<NotificationModel>;
              return list.isEmpty
                  ? AppErrorView(error: "No notifications")
                  : ListView.separated(
                      itemBuilder: (context, index) =>
                          _buildNotificationTile(list[index].notification),
                      separatorBuilder: (context, index) => Divider(
                            color: AppColors.kSecondaryColor,
                          ),
                      itemCount: list.length);
            },
          )),
    );
  }

  Widget _buildNotificationTile(String notification) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.bell_circle),
            AppSpacer(
              wp: .03,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Notification"),
                      Text(IntlC.convertToDateTime(DateTime.now()))
                    ],
                  ),
                  Divider(
                    thickness: .5,
                  ),
                  Text(notification)
                ],
              ),
            ),
          ],
        ),
      );
}
