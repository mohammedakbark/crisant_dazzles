import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/constant/app_images.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewScreen extends StatefulWidget {
  final Object image;
  const ImageViewScreen({super.key, required this.image});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  File? fileImage;
  String? netWorkImage;
  @override
  void initState() {
    if (widget.image is File) {
      fileImage = widget.image as File;
    } else {
      netWorkImage = widget.image as String;
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
            imageProvider:
                netWorkImage != null
                    ? CachedNetworkImageProvider(
                      netWorkImage!,
                      errorListener: (p0) {},
                    )
                    : FileImage(fileImage!),
            maxScale: 1.0,
            minScale: .1,
            heroAttributes: PhotoViewHeroAttributes(tag: 'imageHero'),
            loadingBuilder: (context, event) => AppLoading(),
          ),
        ),
      ),
    );
  }
}
