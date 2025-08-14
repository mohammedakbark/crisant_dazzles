import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/custom_componets.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/custom_app_bar.dart';
import 'package:dazzles/module/office/purchase%20orders/data/model/po_product_model.dart';
import 'package:dazzles/module/office/purchase%20orders/data/provider/get%20po%20products/get_po_products_controller.dart';
import 'package:dazzles/module/office/purchase%20orders/data/provider/get%20po%20products/po_products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PoProductScreen extends ConsumerStatefulWidget {
  final String id;
  final String supplier;
  const PoProductScreen({super.key, required this.id, required this.supplier});

  @override
  ConsumerState<PoProductScreen> createState() => _PendingImagePageState();
}

class _PendingImagePageState extends ConsumerState<PoProductScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    try {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            ref
                .read(getAllPoProductsControllerProvider(widget.id).notifier)
                .hasMore) {
          ref
              .read(getAllPoProductsControllerProvider(widget.id).notifier)
              .loadMore(widget.id);
        }
      });
      Future.microtask(
        () {
          ref.invalidate(getAllPoProductsControllerProvider);
        },
      );
    } catch (e) {
      log("Products screen initialization Error : $e");
    }
  }

  List<int> selectedIds = [];

  bool selectionEnabled = false;

  void onLongPressSelect({int? id}) {
    setState(() {
      selectionEnabled = !selectionEnabled;
      if (!selectionEnabled) {
        selectedIds.clear();
      }
      if (id != null) {
        selectedIds.add(id);
      }
    });
  }

  void onSelectProduct(
    int id,
  ) {
    bool isSelected = selectedIds.contains(id);

    if (selectionEnabled) {
      if (isSelected) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
      if (selectedIds.isEmpty) {
        selectionEnabled = false;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final poProductsController = ref.watch(
      getAllPoProductsControllerProvider(widget.id),
    );

    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: AppBarText(title: widget.supplier),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppBackButton(),

          actions: [
            TextButton(
                onPressed: onLongPressSelect,
                child: Text(
                  selectionEnabled ? "CANCEL" : "SELECT",
                  style: AppStyle.boldStyle(color: AppColors.kWhite),
                ))
          ],
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            return ref.refresh(getAllPoProductsControllerProvider(widget.id));
          },
          child: BuildStateManageComponent(
            stateController: poProductsController,
            errorWidget: (p0, p1) => AppErrorView(
              error: p0.toString(),
              onRetry: () {
                return ref
                    .refresh(getAllPoProductsControllerProvider(widget.id));
              },
            ),
            successWidget: (data) {
              final state = data as PoProductsSuccessState;
              final poProducts = state.poProducts;
              return Column(
                children: [
                  Expanded(
                    child: poProducts.isEmpty
                        ? AppErrorView(
                            error: "No products found!",
                            errorExp: 'products not found in this P/O',
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                AppSpacer(hp: .005),
                            controller: _scrollController,
                            itemCount: poProducts.length,
                            itemBuilder: (context, index) {
                              final product = poProducts[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: index == poProducts.length - 1
                                        ? ResponsiveHelper.hp * .05
                                        : 0),
                                child: _buildProductCard(product),
                              );
                            },
                          ),
                  ),
                  ref
                          .read(getAllPoProductsControllerProvider(widget.id)
                              .notifier)
                          .isLoadingMore
                      ? AppLoading(isTextLoading: true)
                      : SizedBox(),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildProductCard(PoProductModel poProduct) {
    bool isSelected = selectedIds.contains(poProduct.productId);

    return GestureDetector(
      onTap: () => onSelectProduct(poProduct.productId),
      onLongPress: () => onLongPressSelect(id: poProduct.productId),
      child: Container(
        color: isSelected ? AppColors.kWhite.withAlpha(50) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding:
                    EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 5),
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF2A2A2A), // Lighter than scaffold for contrast
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.kFillColor
                              .withAlpha(77), // 0.3 * 255 = 77
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.white.withAlpha(13), // 0.05 * 255 = 13
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withAlpha(77), // 0.3 * 255 = 77
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with product name and ID badge

                          // Main content area
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left side - Product details
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      poProduct.productName,
                                      style: AppStyle.largeStyle(
                                        fontSize: ResponsiveHelper.isTablet()
                                            ? ResponsiveHelper.fontSmall
                                            : 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AppSpacer(
                                      hp: .01,
                                    ),
                                    // Primary details
                                    Wrap(
                                      runSpacing: 8,
                                      spacing: 8,
                                      children: [
                                        _buildFeatureBubble(
                                            "Category", poProduct.category,
                                            isPrimary: true),
                                        _buildFeatureBubble(
                                            "Color", poProduct.color,
                                            isPrimary: true),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // Secondary details
                                    Wrap(
                                      runSpacing: 8,
                                      spacing: 8,
                                      children: [
                                        _buildFeatureBubble("Qty",
                                            poProduct.quantity.toString()),
                                        _buildFeatureBubble(
                                            "Size", poProduct.size),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Right side - Product image and actions
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    // Product image container
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xFF333333), // Slightly lighter than card
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.kGrey
                                              .withAlpha(51), // 0.2 * 255 = 51
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: AppNetworkImage(
                                          fit: BoxFit.cover,
                                          imageFile: poProduct.productPicture,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Update image button
                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   child: ElevatedButton.icon(
                                    //     onPressed: () {},
                                    //     icon: const Icon(
                                    //       Icons.camera_alt_outlined,
                                    //       size: 16,
                                    //       color: Colors.white,
                                    //     ),
                                    //     label: const Text(
                                    //       "Update Image",
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    //     ),
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor: AppColors.kFillColor
                                    //           .withAlpha(204), // 0.8 * 255 = 204
                                    //       foregroundColor: Colors.white,
                                    //       elevation: 0,
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 8),
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(6),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withAlpha(5), // 0.02 * 255 = 5
                              Colors.transparent,
                              Colors.black.withAlpha(26), // 0.1 * 255 = 26
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: buildIdBadge(
                        context,
                        enableCopy: true,
                        poProduct.productId.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Enhanced feature bubble with different styles
  Widget _buildFeatureBubble(String label, String value,
      {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.kFillColor.withAlpha(38) // 0.15 * 255 = 38
            : const Color(0xFF404040), // Dark grey for secondary features
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? AppColors.kFillColor.withAlpha(77) // 0.3 * 255 = 77
              : Colors.grey.withAlpha(51), // 0.2 * 255 = 51
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withAlpha(179), // 0.7 * 255 = 179
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

void showGallerySheet(
    BuildContext context, PoProductModel productModel, WidgetRef ref) {
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
                    fontSize: ResponsiveHelper.isTablet() ? 40 : 20,
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
                          onPressed: () => null,

                          //  UploadImageNotifier()
                          //     .pickImageAndUpload(context, ImageSource.gallery,
                          //         productModel, ref),
                          icon: Icon(
                              size: ResponsiveHelper.isTablet() ? 30 : null,
                              Icons.photo,
                              color: AppColors.kWhite),
                          label: Text(
                            "Gallery",
                            style: AppStyle.boldStyle(
                              fontSize: ResponsiveHelper.isTablet() ? 30 : null,
                            ),
                          ),
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
                          onPressed: () => null,
                          // UploadImageNotifier()
                          //     .pickImageAndUpload(context, ImageSource.camera,
                          //         productModel, ref),
                          icon: Icon(
                            size: ResponsiveHelper.isTablet() ? 30 : null,
                            Icons.camera_alt,
                            color: AppColors.kWhite,
                          ),
                          label: Text(
                            "Camera",
                            style: AppStyle.boldStyle(
                              fontSize: ResponsiveHelper.isTablet() ? 30 : null,
                            ),
                          ),
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
