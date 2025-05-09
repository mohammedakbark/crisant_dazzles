import 'package:dazzles/core/local%20data/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
 const CustomAppBar({super.key})
    : preferredSize = const Size.fromHeight(70);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  String userName = '';
  void getUserName() async {
    final userData = await LoginRefDataBase().getUserData;
    setState(() {
      userName = userData.userName!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size(ResponsiveHelper.wp, ResponsiveHelper.hp * .01),
        child: SizedBox(),
      ),
      automaticallyImplyLeading: false,
      title: ListTile(
        contentPadding: EdgeInsets.all(0),
        // leading: CircleAvatar(radius: 30),
        title: Text(
          "Hi,$userName",
          style: AppStyle.largeStyle(
            fontSize: ResponsiveHelper.fontMedium,
            color: AppColors.kWhite,
          ),
        ),
        subtitle: Text(
          "Welcome back to Dazzles !",
          style: AppStyle.smallStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.fontSmall,
            color: AppColors.kPrimaryColor,
          ),
        ),
        trailing: InkWell(
          onTap: () {
            context.push(notificationScreen);
          },
          child: badges.Badge(
            badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent),
            badgeContent: Text("10", style: AppStyle.mediumStyle(fontSize: 8)),
            position: badges.BadgePosition.topEnd(end: -2, top: -8),
            badgeAnimation: badges.BadgeAnimation.slide(
              curve: Curves.fastOutSlowIn,
              colorChangeAnimationCurve: Curves.easeInCubic,
            ),
            child: CircleAvatar(
              child: Icon(CupertinoIcons.bell_fill, color: AppColors.kWhite),
            ),
          ),
        ),
      ),
    );
  }

  
}
