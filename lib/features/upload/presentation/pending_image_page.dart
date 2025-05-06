import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/providers/get_pending_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solar_icons/solar_icons.dart';

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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          ref.read(getAllPendingProductControllerProvider.notifier).hasMore) {
        ref.read(getAllPendingProductControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingImageController = ref.watch(
      getAllPendingProductControllerProvider,
    );

    return RefreshIndicator(
      onRefresh: () async {
        return ref.refresh(getAllPendingProductControllerProvider);
      },
      child: BuildStateManageComponent(
        controller: pendingImageController,
        errorWidget:
            (p0, p1) => AppErrorView(
              error: p0.toString(),
              onRetry: () {
                return ref.refresh(getAllPendingProductControllerProvider);
              },
            ),
        successWidget: (data) {
          final pending = data as List<ProductModel>;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => AppSpacer(hp: .01),
                  controller: _scrollController,
                  itemCount: pending.length,
                  itemBuilder: (context, index) {
                    final product = pending[index];
                    return _buildProductCard(product);
                  },
                ),
              ),
              ref
                      .read(getAllPendingProductControllerProvider.notifier)
                      .isLoadingMore
                  ? AppLoading(isTextLoading: true)
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      if (mounted) {
        context.pop();
        context.push(imagePreview, extra: pickedFile.path);
      }
    }
  }

  void showGallerySheet(BuildContext context) {
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
                            onPressed: () => _pickImage(ImageSource.gallery),
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
                            onPressed: () => _pickImage(ImageSource.camera),
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

  Widget _buildProductCard(ProductModel product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor.withAlpha(250),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.kWhite.withAlpha(30),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Row(
              children: [
                SizedBox(
                  width: ResponsiveHelper.wp * .55,
                  child: AppNetworkImage(
                    imageFile:
                        "${ApiConstants.imageBaseUrl}${product.productPicture ?? ''}",

                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    onTap: () {
                      showGallerySheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            SolarIconsOutline.camera,
                            color: AppColors.kWhite,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Capture Picture",
                            style: AppStyle.mediumStyle(
                              color: AppColors.kWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: AppStyle.boldStyle(fontSize: 18),
                ),
                AppSpacer(hp: .005),
                Text(
                  "Category: ${product.category}",
                  style: AppStyle.normalStyle(
                    color: AppColors.kTextPrimaryColor,
                  ),
                ),
                AppSpacer(hp: .005),
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
                        style: AppStyle.mediumStyle(color: AppColors.kWhite),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
