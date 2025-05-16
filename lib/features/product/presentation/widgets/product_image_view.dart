import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/presentation/pending_image_page.dart';
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
            errorBuilder: (context, error, stackTrace) =>
                AppErrorView(error: error.toString()),
            imageProvider: netWorkImage != null
                ? CachedNetworkImageProvider(
                    "${netWorkImage}?v=${DateTime.now().microsecondsSinceEpoch}",
                    errorListener: (p0) {
                      log(p0.toString());
                    },
                  )
                : FileImage(fileImage!) as ImageProvider,
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
            onTap: () => showGallerySheet(context, widget.productModel!, ref),
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
}
