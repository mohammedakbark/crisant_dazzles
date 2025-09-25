import 'dart:developer';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/custom_componets.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/navigation/data/model/image_pending_product_model.dart';
import 'package:dazzles/features/navigation/data/provider/image%20pending%20controller/image_pending_controller.dart';
import 'package:dazzles/features/navigation/data/provider/image%20pending%20controller/image_pending_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PendingImageScreen extends ConsumerStatefulWidget {
  const PendingImageScreen({super.key});

  @override
  ConsumerState<PendingImageScreen> createState() => _PendingImageScreenState();
}

class _PendingImageScreenState extends ConsumerState<PendingImageScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    try {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            ref.read(imagePendingControllerProvider.notifier).hasMore) {
          ref.read(imagePendingControllerProvider.notifier).loadMore();
        }
      });
    } catch (e) {
      log("Error");
    }
    Future.microtask(() {
      ref.invalidate(imagePendingControllerProvider);
    });
  }

  String imageVersion = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    final isTab = ResponsiveHelper.isTablet();

    final upcomingProductController = ref.watch(imagePendingControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: AppBarText(title: "Image pendings"),
      ),
      body: BuildStateManageComponent(
        stateController: upcomingProductController,
        successWidget: (data) {
          final state = data as ImagePendingState;
          final products = state.products;

          return products.isEmpty
              ? AppErrorView(error: "No Upcoming products found")
              : Column(
                  children: [
                    ref
                            .watch(imagePendingControllerProvider.notifier)
                            .isLoadingMore
                        ? AppLoading(isTextLoading: true)
                        : AppSpacer(hp: .02),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTab ? 3 : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) =>
                            _buildTile(products[index]),
                      ),
                    ),
                  ],
                );
        },
        errorWidget: (p0, p1) => AppErrorView(
          error: p0.toString(),
          onRetry: () {
            return ref.refresh(imagePendingControllerProvider);
          },
        ),
      ),
    );
  }

  Widget _buildTile(ImagePendingProductsModel product) {
    return InkWell(
      onTap: () {
        context.push(viewAndEditProductScreen,
            extra: {"id": product.id, "productName": product.productName});
        // context.push(
        //   openImage,
        //   extra: {
        //     "heroTag": product.id.toString(),
        //     "path":
        //         "${ApiConstants.imageBaseUrl}${product.productPicture ?? ''}",
        //     "enableEditButton": true,
        //     "prouctModel": product,
        //   },
        // );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kPrimaryColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Hero(
                        tag: product.id.toString(),
                        child: AppNetworkImage(
                          //  errorIcon: Image.asset(AppImages.defaultImage),

                          imageVersion: imageVersion,
                          imageFile:
                              "${ApiConstants.mediaBaseUrl}${product.productPicture}",
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.category,
                          style: AppStyle.boldStyle(
                              fontSize: ResponsiveHelper.isTablet()
                                  ? ResponsiveHelper.fontExtraSmall
                                  : null)),
                      AppSpacer(
                        hp: .002,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.kPrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                product.productName,
                                style: AppStyle.mediumStyle(
                                  fontSize: ResponsiveHelper.isTablet()
                                      ? ResponsiveHelper.fontExtraSmall
                                      : null,
                                  color: AppColors.kSecondaryColor,
                                ),
                              ),
                            ),
                            AppSpacer(
                              wp: .01,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      ResponsiveHelper.isTablet() ? 12 : 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.kBgColor.withAlpha(100),
                              ),
                              child: Text(
                                product.productSize,
                                style: AppStyle.mediumStyle(
                                    fontSize: ResponsiveHelper.isTablet()
                                        ? ResponsiveHelper.fontExtraSmall
                                        : null),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // AppSpacer(
                      //   hp: .005,
                      // ),
                      // Text(
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: AppStyle.mediumStyle(
                      //     fontSize: ResponsiveHelper.isTablet()
                      //         ? ResponsiveHelper.fontExtraSmall
                      //         : null,
                      //     color: AppColors.kWhite,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              left: 10,
              right: 10,
              top: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildIdBadge(
                    context,
                    product.id.toString(),
                    enableCopy: true,
                  ),
                  Icon(
                    CupertinoIcons.arrow_right_circle,
                    size: ResponsiveHelper.isTablet() ? 40 : null,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
