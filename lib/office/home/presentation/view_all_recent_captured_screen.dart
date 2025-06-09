import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/custom_componets.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/constant/app_images.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/office/home/data/models/recently_captured.dart';
import 'package:dazzles/office/home/data/providers/recently_captured_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewAllRecentCapturedScreen extends ConsumerStatefulWidget {
  const ViewAllRecentCapturedScreen({super.key});

  @override
  ConsumerState<ViewAllRecentCapturedScreen> createState() =>
      _ViewAllRecentCapturedScreenState();
}

class _ViewAllRecentCapturedScreenState
    extends ConsumerState<ViewAllRecentCapturedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(recntlyCapturedControllerProvider);
    });
  }

  final imageVersion = DateTime.now().microsecondsSinceEpoch.toString();
  @override
  Widget build(BuildContext context) {
    // final recentCapturedController = ;
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Recently Captured", style: AppStyle.boldStyle()),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          return ref.refresh(recntlyCapturedControllerProvider);
        },
        child: BuildStateManageComponent(
          stateController: ref.watch(
            recntlyCapturedControllerProvider,
          ),
          errorWidget: (p0, p1) => AppErrorView(
            error: p0.toString(),
            onRetry: () {
              return ref.refresh(recntlyCapturedControllerProvider);
            },
          ),
          successWidget: (p0) {
            final data = p0 as List<RecentCapturedModel>;
            return data.isEmpty
                ? AppErrorView(error: "Nothing is captured recently")
                : GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        context.push(viewAndEditProductScreen, extra: {
                          "id": data[index].productId,
                          "productName": data[index].productName
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.kBorderColor,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: AppColors.kPrimaryColor.withAlpha(30),
                            ),
                          ],
                          // border: Border.all(color: AppColors.kPrimaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: data[index].productId.toString(),
                              child: AppNetworkImage(
                                imageVersion: imageVersion,
                                // errorIcon: Image.asset(AppImages.defaultImage),
                                fit: BoxFit.cover,
                                imageFile: ApiConstants.imageBaseUrl +
                                    data[index].productPicture,
                              ),
                            ),
                            Positioned(
                                left: 10,
                                top: 10,
                                child: buildIdBadge(
                                    context, data[index].productId.toString(),
                                    enableCopy: true)),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  width: ResponsiveHelper.wp * .45,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 3, bottom: 3),
                                  decoration:
                                      BoxDecoration(color: AppColors.kBgColor),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data[index].productName,
                                        style: AppStyle.mediumStyle(
                                            color: AppColors.kWhite),
                                      ),
                                      Icon(
                                        CupertinoIcons.arrow_right_circle,
                                        color: AppColors.kWhite,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
