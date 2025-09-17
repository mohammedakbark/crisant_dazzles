import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/camera%20and%20upload/data/providers/camera%20controller/camera_controller.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends ConsumerStatefulWidget {
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
  ConsumerState<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends ConsumerState<ImageViewScreen> {
  File? fileImage;
  String? netWorkImage;

  // Append a version query param to force reload of image
  final version = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    try {
      if (widget.image is File) {
        fileImage = widget.image as File;
      } else if (widget.image is String) {
        netWorkImage = widget.image as String;
      }
    } catch (e) {
      log("Image parsing error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        // actions: [)],
      ),
      body: Container(
        alignment: Alignment.center,
        height: ResponsiveHelper.hp * .8,
        child: Center(
          child: PhotoView(
            errorBuilder: (context, error, stackTrace) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: ResponsiveHelper.isTablet() ? 60 : null,
                  Icons.broken_image_rounded,
                  color: AppColors.kFillColor,
                ),
                Text(
                  "Image not found!",
                  style: AppStyle.boldStyle(color: AppColors.kFillColor),
                )
              ],
            ),
            imageProvider: netWorkImage != null
                ? CachedNetworkImageProvider(
                    "${netWorkImage}?v=$version", // ✅ Cache-busting query
                  )
                : FileImage(fileImage!) as ImageProvider,
            maxScale: 1.0,
            minScale: .1,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
            loadingBuilder: (context, event) => const AppLoading(),
          ),
        ),
      ),
      bottomNavigationBar: _buildEditButton(),
    );
  }

  Widget _buildEditButton() {
    return widget.enableEditButton
        ? InkWell(
            onTap: () => showGallerySheet(context, ref,
                productModel: widget.productModel!),
            child: Container(
              margin: EdgeInsets.all(50),
              alignment: Alignment.center,
              color: AppColors.kBgColor,
              height: ResponsiveHelper.isTablet() ? 100 : 30,
              child: Text(
                "Update Image",
                style: AppStyle.largeStyle(
                  fontSize: ResponsiveHelper.fontRegular,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
