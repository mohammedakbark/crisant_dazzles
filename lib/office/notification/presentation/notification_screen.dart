import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:flutter/cupertino.dart';
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
      body: RefreshIndicator.adaptive(
        onRefresh: () async{
          
        },
        child: ListView.separated(
            itemBuilder: (context, index) => _buildNotificationTile(),
            separatorBuilder: (context, index) => Divider(
                  color: AppColors.kSecondaryColor,
                ),
            itemCount: 3),
      ),
    );
  }

  Widget _buildNotificationTile() => Container(
    margin: EdgeInsets.symmetric(horizontal: 15,
    vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.bell_circle),
            AppSpacer(wp: .03,),
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
                  Divider(thickness: .5,),
                  Text("Your salary 977439 is credited to ßyour bank account.")
                ],
              ),
            ),
          ],
        ),
      );
}
