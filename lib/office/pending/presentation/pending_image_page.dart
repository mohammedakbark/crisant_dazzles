import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/componets.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/office/product/data/models/product_model.dart';
import 'package:dazzles/office/pending/data/providers/get%20pending%20products/get_pending_products_controller.dart';
import 'package:dazzles/office/pending/data/providers/get%20pending%20products/pending_products_state.dart';
import 'package:dazzles/office/pending/data/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PendingImagePage extends ConsumerStatefulWidget {
  const PendingImagePage({super.key});

  @override
  ConsumerState<PendingImagePage> createState() => _PendingImagePageState();
}

class _PendingImagePageState extends ConsumerState<PendingImagePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    try {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            ref.read(getAllPendingProductControllerProvider.notifier).hasMore) {
          ref.read(getAllPendingProductControllerProvider.notifier).loadMore();
        }
      });
      Future.microtask(() {
        ref.invalidate(getAllPendingProductControllerProvider);
      },);
    } catch (e) {
      log("Pending screen initialization Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingImageController = ref.watch(
      getAllPendingProductControllerProvider,
    );

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        return ref.refresh(getAllPendingProductControllerProvider);
      },
      child: BuildStateManageComponent(
        stateController: pendingImageController,
        errorWidget: (p0, p1) => AppErrorView(
          error: p0.toString(),
          onRetry: () {
            return ref.refresh(getAllPendingProductControllerProvider);
          },
        ),
        successWidget: (data) {
          final state = data as PendingProductSuccessState;
          final pending = state.products;
          return Column(
            children: [
              ref
                      .read(getAllPendingProductControllerProvider.notifier)
                      .isLoadingMore
                  ? AppLoading(isTextLoading: true)
                  : SizedBox(),
              Expanded(
                child: pending.isEmpty
                    ? AppErrorView(
                        error: "No pending data!",
                        errorExp: 'No more products in pending to update photo',
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) =>
                            AppSpacer(hp: .005),
                        controller: _scrollController,
                        itemCount: pending.length,
                        itemBuilder: (context, index) {
                          final product = pending[index];
                          return _buildProductCard(product);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      decoration: BoxDecoration(
          color: AppColors.kBorderColor.withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kFillColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.productName,
                      style: AppStyle.largeStyle(fontSize: 20),
                    ),
                    buildIdBadge(
                      context,
                      enableCopy: true,
                      product.id.toString(),
                    ),
                  ],
                ),
                AppSpacer(
                  hp: .01,
                ),
                Text(
                  "Category: ${product.category}",
                  style: AppStyle.normalStyle(
                    color: AppColors.kTextPrimaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Color: ${product.color}",
                      style: AppStyle.normalStyle(
                        color: AppColors.kTextPrimaryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withAlpha(70),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Size: ${product.productSize}",
                        style: AppStyle.mediumStyle(
                          color: AppColors.kWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showGallerySheet(context, product, ref);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: AppColors.kBgColor),
              alignment: Alignment.center,
              child: Text(
                "Upload Image",
                style: AppStyle.largeStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void showGallerySheet(
    BuildContext context, ProductModel productModel, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return AnimatedPadding(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SlideInUp(
          duration: Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Image Source',
                  style: AppStyle.mediumStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ZoomIn(
                        duration: Duration(milliseconds: 600),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kDeepPurple,
                            foregroundColor: AppColors.kWhite,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => UploadImageNotifier()
                              .pickImageAndUpload(context, ImageSource.gallery,
                                  productModel, ref),
                          icon: Icon(Icons.photo, color: AppColors.kWhite),
                          label: Text("Gallery"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ZoomIn(
                        duration: Duration(milliseconds: 800),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kTeal,
                            foregroundColor: AppColors.kWhite,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => UploadImageNotifier()
                              .pickImageAndUpload(context, ImageSource.camera,
                                  productModel, ref),
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppColors.kWhite,
                          ),
                          label: Text("Camera"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
