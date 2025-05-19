
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/local/hive/controllers/upload_manager.dart';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  const CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(70);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  int? count;
  @override
  void initState() {
    getUserName();
    super.initState();
    Future.microtask(
      () {
        ref.invalidate(uploadManagerProvider);
      },
    );
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
    final uploadManagerState = ref.watch(uploadManagerProvider);
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
      ),
      actions: [
        // Padding(
        //   padding: EdgeInsets.only(right: 10),
        //   child: BuildStateManageComponent(
        //       stateController: uploadManagerState,
        //       successWidget: (data) {
        //         final notif = data as List<UploadPhotoModel>;
        //         return InkWell(
        //           overlayColor: WidgetStatePropertyAll(Colors.transparent),
        //           onTap: () {
        //             context.push(notificationScreen);
        //           },
        //           child: badges.Badge(
        //             showBadge: notif.isNotEmpty,
        //             badgeStyle: badges.BadgeStyle(badgeColor: AppColors.kWhite),
        //             badgeContent: Text(notif.length.toString(),
        //                 style: AppStyle.mediumStyle(
        //                     fontSize: 8, color: AppColors.kErrorPrimary)),
        //             position: badges.BadgePosition.topEnd(end: -2, top: -8),
        //             badgeAnimation: badges.BadgeAnimation.slide(
        //               curve: Curves.fastOutSlowIn,
        //               colorChangeAnimationCurve: Curves.easeInCubic,
        //             ),
        //             child: CircleAvatar(
        //               backgroundColor: AppColors.kPrimaryColor.withAlpha(50),
        //               child: Icon(CupertinoIcons.camera,
        //                   size: 18, color: AppColors.kWhite),
        //             ),
        //           ),
        //         );
        //       }),
        // ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: BuildStateManageComponent(
              stateController: uploadManagerState,
              successWidget: (data) {
                final notif = data as List<UploadPhotoModel>;
                return InkWell(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  onTap: () {
                    context.push(notificationScreen);
                  },
                  child: badges.Badge(
                    showBadge: notif.isNotEmpty,
                    badgeStyle: badges.BadgeStyle(badgeColor: AppColors.kWhite),
                    badgeContent: Text(notif.length.toString(),
                        style: AppStyle.mediumStyle(
                            fontSize: 8, color: AppColors.kErrorPrimary)),
                    position: badges.BadgePosition.topEnd(end: -2, top: -8),
                    badgeAnimation: badges.BadgeAnimation.slide(
                      curve: Curves.fastOutSlowIn,
                      colorChangeAnimationCurve: Curves.easeInCubic,
                    ),
                    child: CircleAvatar(
                      backgroundColor: AppColors.kPrimaryColor.withAlpha(50),
                      child: Icon(CupertinoIcons.cloud_upload,
                          size: 18, color: AppColors.kWhite),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
