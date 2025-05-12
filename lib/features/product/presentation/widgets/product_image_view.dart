import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/constant/app_images.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/data/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewScreen extends StatefulWidget {
  final Object image;
  final String heroTag;
  final ProductModel? productModel;
  final bool enableEditButton;
  const ImageViewScreen({
    super.key,
    required this.heroTag,
    required this.image,
    required this.productModel,
    this.enableEditButton = false,
  });

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  File? fileImage;
  String? netWorkImage;
  @override
  void initState() {
    try {
      if (widget.image is File) {
        fileImage = widget.image as File;
      } else {
        netWorkImage = widget.image as String;
      }
    } catch (e) {
      log(e.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton()),
      body: Container(
        alignment: Alignment.center,
        height: ResponsiveHelper.hp * .8,

        child: Center(
          child: PhotoView(
            errorBuilder:
                (context, error, stackTrace) =>
                    AppErrorView(error: error.toString()),
            imageProvider:
                netWorkImage != null
                    ? CachedNetworkImageProvider(
                      netWorkImage!,
                      errorListener: (p0) {
                        log(p0.toString());
                      },
                    )
                    : FileImage(fileImage!),
            maxScale: 1.0,
            minScale: .1,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
            loadingBuilder: (context, event) => AppLoading(),
          ),
        ),
      ),
      bottomNavigationBar: _buildEditButton(),
    );
  }

  Widget _buildEditButton() {
    return widget.enableEditButton
        ? InkWell(
          onTap: () => showGallerySheet(context, widget.productModel!),
          child: Container(
            alignment: Alignment.center,
            color: AppColors.kBgColor,
            height: 100,

            child: Text(
              "Update Image",
              style: AppStyle.largeStyle(
                fontSize: ResponsiveHelper.fontRegular,
              ),
            ),
          ),
        )
        : SizedBox();
  }

  void showGallerySheet(BuildContext context, ProductModel productModel) {
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
                            onPressed:
                                () => UploadImageNotifier.pickImage(
                                  context,
                                  ImageSource.gallery,
                                  productModel,
                                ),
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
                            onPressed:
                                () => UploadImageNotifier.pickImage(
                                  context,
                                  ImageSource.camera,
                                  productModel,
                                ),
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
}
