import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/componets.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/office/product/data/models/product_model.dart';
import 'package:dazzles/office/pending/data/providers/select%20&%20search%20product/product_id_selection_controller.dart';
import 'package:dazzles/office/pending/data/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class ProductSelectionScreen extends ConsumerStatefulWidget {
  final File fileImage;
  const ProductSelectionScreen({super.key, required this.fileImage});

  @override
  ConsumerState<ProductSelectionScreen> createState() =>
      _CopyMoreProdutcsScreenState();
}

class _CopyMoreProdutcsScreenState
    extends ConsumerState<ProductSelectionScreen> {
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  final _findIDController = TextEditingController();
  final imageVersion = DateTime.timestamp().toString();

  @override
  void initState() {
    Future.microtask(
      () {
        ref.invalidate(selectAndSearchProductControllerProvider);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text("Update More Product", style: AppStyle.boldStyle()),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppBackButton(),
        ),
        body: AppMargin(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.memory(widget.fileImage),
              _buildSearchBox(),
              AppSpacer(hp: .01),
              _buildSelectedIds(),
              AppSpacer(hp: .01),
              _buidButton(),
            ],
          ),
        ),
        // bottomNavigationBar: 
      ),
    );
  }

  _buildSelectedIds() {
    final selectedProuducts = ref.watch(
      selectAndSearchProductControllerProvider,
    );
    final selectedProuductsController = ref.read(
      selectAndSearchProductControllerProvider.notifier,
    );

    return Expanded(
      child: selectedProuducts.selectedIds.isEmpty
          ? AppErrorView(
              error: "No Product Selected!",
              errorExp:
                  "Search or Scan QRcode and choose the products to update.",
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    AppSpacer(hp: .01,),
                Text("Selected Products", style: AppStyle.boldStyle(fontSize: 15)),
                AppSpacer(hp: .01,),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: selectedProuducts.selectedIds.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final model = selectedProuducts.selectedIds[index];
                      return SlideInLeft(
                        duration: Duration(microseconds: 200),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            InkWell(
                              onTap: () {
                                context.push(
                                  openImage,
                                  extra: {
                                    "heroTag": model.id.toString(),
                                    "path":
                                        "${ApiConstants.imageBaseUrl}${model.productPicture}",
                                  },
                                );
                              },
                              child: Container(
                                width: ResponsiveHelper.wp,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                margin: EdgeInsets.only(
                                  right: 8,
                                  bottom: 5,
                                  top: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColors.kFillColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Hero(
                                          tag: model.id.toString(),
                                          child: AppNetworkImage(
                                            imageVersion: imageVersion,
                                            imageFile:
                                                "${ApiConstants.imageBaseUrl}${model.productPicture}",
                                          ),
                                        ),
                                      ),
                                    ),
                                    AppSpacer(hp: .005),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          model.productName.toString(),
                                          style: AppStyle.boldStyle(
                                            color: AppColors.kTeal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppSpacer(hp: .005),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            "Color : ${model.color}",
                                            style: AppStyle.smallStyle(
                                              color:
                                                  AppColors.kTextPrimaryColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          " Size : ${model.productSize}",
                                          style: AppStyle.smallStyle(
                                            color: AppColors.kTextPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              child: InkWell(
                                onTap: () {
                                  selectedProuductsController.remove(model);
                                },
                                child: Icon(
                                  SolarIconsBold.closeCircle,
                                  size: 20,
                                  color: AppColors.kErrorPrimary,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 20,
                              child: buildIdBadge(context, model.id.toString()),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // List<int> similarProducts = [
  Widget _buildSearchBox() {
    final productSelectionState = ref.watch(
      selectAndSearchProductControllerProvider,
    );
    final controller = ref.read(
      selectAndSearchProductControllerProvider.notifier,
    );
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _findIDController,
              onChanged: (value) {
                _debouncer.run(() {
                  controller.onSearchProduct(value);
                });
              },
              keyboardType: TextInputType.number,
              style: AppStyle.normalStyle(),
              cursorColor: AppColors.kBorderColor,
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kErrorPrimary),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kErrorPrimary),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: productSelectionState.errorMessage,
                errorStyle: AppStyle.smallStyle(color: AppColors.kErrorPrimary),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                hintText: "Enter product id or scan QRcode",
                hintStyle: AppStyle.normalStyle(color: AppColors.kBorderColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kBorderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kBorderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kBorderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: productSelectionState.errorMessage != null
                      ? AppColors.kErrorPrimary
                      : AppColors.kBorderColor,
                ),
                suffixIcon: productSelectionState.enableAddButton &&
                        productSelectionState.productModel != null
                    ? ZoomIn(
                        child: InkWell(
                          onTap: () {
                            controller.add(
                              productSelectionState.productModel!,
                              context,
                              showSheet: (onCancel, onReplace) {
                                _showReplacePicutreConfirmation(
                                  context: context,
                                  selectedProduct:
                                      productSelectionState.productModel!,
                                  onReplace: onReplace,
                                  onCanel: onCancel,
                                );
                              },
                            );
                            _findIDController.clear();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10),
                              ),
                              color: AppColors.kDeepPurple,
                            ),
                            child: Icon(Icons.add, color: AppColors.kWhite),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          AppSpacer(wp: .01),
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: AppColors.kBorderColor),
              ),
              child: Icon(Icons.qr_code_2_rounded, color: AppColors.kBorderColor),
            ),
          ),
        ],
      ),
    );
  }

  _buidButton() {
    final uploadImageState = ref.watch(uploadImageControllerProvider);

    final productSelectionState = ref.watch(
      selectAndSearchProductControllerProvider,
    );
    return BuildStateManageComponent(
      stateController: uploadImageState,
      successWidget: (data) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ZoomIn(
                  duration: Duration(milliseconds: 700),
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(route),
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.kWhite,
                    ),
                    label: Text(
                      "Discard",
                      style: AppStyle.normalStyle(color: AppColors.kWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kErrorPrimary,
                      foregroundColor: AppColors.kWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                AppSpacer(wp: .03),
                Expanded(
                  child: ZoomIn(
                    duration: Duration(milliseconds: 700),
                    child: SizedBox(
                     
                      child: ElevatedButton.icon(
                        onPressed: productSelectionState.selectedIds.isNotEmpty
                            ? () {
                                final container = ProviderContainer();
                                container
                                    .read(
                                        uploadImageControllerProvider.notifier)
                                    .uploadMultipleIds(
                                      context,
                                      ref,
                                      widget.fileImage,
                                    );
                              }
                            : null,
                        icon: Icon(
                          Icons.cloud_upload_outlined,
                          color: productSelectionState.selectedIds.isNotEmpty
                              ? AppColors.kWhite
                              : AppColors.kTextPrimaryColor,
                        ),
                        label: Text(
                          "Upload",
                          style: AppStyle.normalStyle(
                            color: productSelectionState.selectedIds.isNotEmpty
                                ? AppColors.kWhite
                                : AppColors.kTextPrimaryColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kGreen,
                          foregroundColor: AppColors.kWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showReplacePicutreConfirmation({
    required BuildContext context,
    required ProductModel selectedProduct,
    required VoidCallback onReplace,
    required VoidCallback onCanel,
  }) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return AnimatedPadding(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SlideInUp(
            duration: Duration(microseconds: 400),
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
                    "Replace Product Image?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You're about to replace the current product image. Please confirm.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  SlideInDown(
                    duration: Duration(milliseconds: 800),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text("Current"),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  height: 120,
                                  child: AppNetworkImage(
                                    imageVersion:
                                        DateTime.timestamp().toString(),
                                    imageFile:
                                        '${ApiConstants.imageBaseUrl}${selectedProduct.productPicture}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.arrow_forward, color: Colors.grey),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text("New"),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  widget.fileImage,
                                  height: 120,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ZoomIn(
                          duration: Duration(milliseconds: 800),
                          child: OutlinedButton(
                            onPressed: () => onCanel(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.kWhite,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColors.kTeal),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text("Cancel"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ZoomIn(
                          duration: Duration(milliseconds: 800),
                          child: ElevatedButton(
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
                            onPressed: () => onReplace(),
                            child: Text("Replace"),
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

  // void _onUpload(BuildContext context, UploadImageNotifier controller) async {
  //   final state = ref.read(selectAndSearchProductControllerProvider);

  //   List<int> ids = [];
  //   for (var i in state.selectedIds) {
  //     ids.add(i.id);
  //   }

  //   await controller.uploadImage(
  //     context: context,
  //     productIds: ids,
  //     file: widget.fileImage,
  //   );
  //   ref.invalidate(getAllPendingProductControllerProvider);
  //   ref.invalidate(dashboardControllerProvider);
  //   if (context.mounted) {
  //     context.go(route);
  //   }
  // }
}
