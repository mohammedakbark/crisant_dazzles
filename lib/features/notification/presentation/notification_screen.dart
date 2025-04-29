import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Notifications", style: AppStyle.boldStyle()),
      ),
      body: AppMargin(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return _buitlNotificationTile();
          },
          separatorBuilder: (context, index) => AppSpacer(hp: .03),
          itemCount: 10,
        ),
      ),
    );
  }

  Widget _buitlNotificationTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kPrimaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notifiation one . new photo uploaded "),
          AppSpacer(hp: .01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "12-12-2023",
                style: AppStyle.normalStyle(color: AppColors.kTextPrimaryColor),
              ),
              Text(
                "01:12 Am",
                style: AppStyle.normalStyle(color: AppColors.kTextPrimaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
