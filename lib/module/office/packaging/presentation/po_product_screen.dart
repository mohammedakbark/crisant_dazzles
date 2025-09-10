import 'dart:developer';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/custom_componets.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/camera%20and%20upload/data/providers/camera%20controller/camera_controller.dart';
import 'package:dazzles/module/office/packaging/data/model/po_product_model.dart';
import 'package:dazzles/module/office/packaging/data/provider/get%20po%20products/get_po_products_controller.dart';
import 'package:dazzles/module/office/packaging/data/provider/get%20po%20products/po_products_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';

class PoProductScreen extends ConsumerStatefulWidget {
  final String id;
  final String supplier;
  const PoProductScreen({super.key, required this.id, required this.supplier});

  @override
  ConsumerState<PoProductScreen> createState() => _PendingImagePageState();
}

class _PendingImagePageState extends ConsumerState<PoProductScreen> {
  final _scrollController = ScrollController();
  String imageVersion = DateTime.now().microsecondsSinceEpoch.toString();
  late Debouncer _debauncer;

  @override
  void initState() {
    super.initState();
    _debauncer = Debouncer(milliseconds: 200);
    Future.microtask(
      () {
        ref.invalidate(getAllPoProductsControllerProvider);
      },
    );
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
    } catch (e) {
      log("Products screen initialization Error : $e");
    }
  }

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final poProductsController = ref.watch(
      getAllPoProductsControllerProvider(widget.id.toString()),
    );
    final isTab = ResponsiveHelper.isTablet();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        // automaticallyImplyLeading: false,
        title: AppBarText(title: widget.supplier),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppBackButton(),

        actions: [
          if (poProductsController.value != null)
            TextButton(
                onPressed: ref
                    .read(
                      getAllPoProductsControllerProvider(widget.id).notifier,
                    )
                    .onEnableSelection,
                child: Text(
                  poProductsController.value!.isSelectionEnabled
                      ? "Cancel"
                      : "Select",
                  style: AppStyle.boldStyle(color: Colors.blue),
                ))
        ],
      ),
      body: Column(
        children: [
          AppMargin(
              child: TextFormField(
            controller: _searchController,
            onChanged: (vaue) {
              _debauncer.run(
                () {
                  ref
                      .read(getAllPoProductsControllerProvider(widget.id)
                          .notifier)
                      .onSearchProduct(widget.id, vaue);
                },
              );
            },
            style: AppStyle.normalStyle(
                color: AppColors.kPrimaryColor,
                fontSize: isTab ? ResponsiveHelper.fontSmall : null),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: isTab ? 20 : 0),
              hintText: "Search Product",
              hintStyle: AppStyle.normalStyle(
                color: AppColors.kPrimaryColor,
                fontSize: isTab ? ResponsiveHelper.fontSmall : null,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              fillColor: AppColors.kFillColor.withAlpha(70),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                    left: isTab ? 20 : 8, right: isTab ? 10 : 0),
                child: Icon(
                  size: isTab ? 40 : null,
                  SolarIconsOutline.magnifier,
                  color: AppColors.kPrimaryColor,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        return ref.refresh(
                            getAllPoProductsControllerProvider(widget.id));
                      },
                      icon: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: isTab ? 20 : 8),
                        child: Icon(
                          Icons.clear,
                          size: isTab ? 40 : null,
                        ),
                      ),
                    )
                  : null,
            ),
          )),
          AppSpacer(
            hp: .01,
          ),
          Expanded(
            child: Container(
              color: AppColors.kBgColor,
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  _searchController.clear();
                  imageVersion =
                      DateTime.now().microsecondsSinceEpoch.toString();
                  return ref
                      .refresh(getAllPoProductsControllerProvider(widget.id));
                },
                child: BuildStateManageComponent(
                  stateController: poProductsController,
                  errorWidget: (p0, p1) => AppErrorView(
                    error: p0.toString(),
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
                                .read(getAllPoProductsControllerProvider(
                                        widget.id)
                                    .notifier)
                                .isLoadingMore
                            ? AppLoading(isTextLoading: true)
                            : SizedBox(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductCard(PoProductModel poProduct) {
    final poProductsNotifier = ref.read(
      getAllPoProductsControllerProvider(widget.id).notifier,
    );
    final poProductsController = ref.watch(
      getAllPoProductsControllerProvider(widget.id),
    );
    bool isSelected =
        poProductsController.value!.selectedIds.contains(poProduct.productId);
    return GestureDetector(
      onTap: () async {
        if (!poProductsController.value!.isSelectionEnabled) {
          showGallerySheet(context, ref,
              supplierId: widget.id, productId: poProduct.productId);
        } else {
          poProductsNotifier.onSelectProducts(poProduct.productId);
        }
      },
      onLongPress: () =>
          poProductsNotifier.onEnableSelection(id: poProduct.productId),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.kFillColor.withAlpha(77),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(13),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.black.withAlpha(77),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      imageVersion: imageVersion,
                                      fit: BoxFit.cover,
                                      imageFile: ApiConstants.mediaBaseUrl +
                                          poProduct.productPicture,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

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

                          const SizedBox(width: 20),

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

                                const SizedBox(height: 5),

                                // Secondary details
                                Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: [
                                    _buildFeatureBubble(
                                        "Qty", poProduct.quantity.toString()),
                                    _buildFeatureBubble("Size", poProduct.size),
                                  ],
                                ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Container(
              color: isSelected ? AppColors.kWhite.withAlpha(30) : null,
            ),
          ),
          if (poProductsController.value!.isSelectionEnabled)
            Positioned(
                bottom: 5,
                right: 10,
                child: Checkbox.adaptive(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(AppColors.kTeal),
                    value: isSelected,
                    onChanged: (value) {}))
        ],
        clipBehavior: Clip.hardEdge,
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

  Widget _buildBottomBar() {
    final poProductsController = ref.watch(
      getAllPoProductsControllerProvider(widget.id),
    );
    final isEnabled = poProductsController.value != null &&
        poProductsController.value!.selectedIds.isNotEmpty;
    return isEnabled
        ? InkWell(
            onTap: () {
              showGallerySheet(context, ref, supplierId: widget.id);
            },
            child: Container(
              alignment: Alignment.center,
              height: ResponsiveHelper.hp * .1,
              decoration: BoxDecoration(
                color: AppColors.kFillColor,
              ),
              child: Text(
                "Update Image",
                style: AppStyle.boldStyle(fontSize: 18),
              ),
            ),
          )
        : SizedBox();
  }
}
