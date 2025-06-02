import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzles/core/components/app_loading.dart';

import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageFile;
  final Widget? errorIcon;
  final String? imageVersion;

  final String? userName;
  final double? iconSize;
  final double? nameSize;
  final BoxFit? fit;
  final Color? userNameColor;
  const AppNetworkImage({
    super.key,
    required this.imageFile,
    this.errorIcon,
    this.imageVersion,
    this.iconSize,
    this.userName,
    this.nameSize,
    this.userNameColor,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: fit,
      imageUrl: "${imageFile}?v=$imageVersion" ,
      placeholder: (context, url) => AppLoading(),
      errorListener: (value) {},
      
      errorWidget: (context, url, error) =>
          (userName != null && userName!.isNotEmpty)
              ? Center(
                  child: Text(
                    userName![0],
                    style: AppStyle.boldStyle(
                      fontSize: nameSize ?? ResponsiveHelper.fontMedium,
                      fontWeight: FontWeight.bold,
                      color: userNameColor ?? AppColors.kWhite,
                    ),
                  ),
                )
              : errorIcon ?? Icon(
                  size: iconSize,
                  Icons.broken_image_rounded,
                  color: AppColors.kFillColor,
                ),
    );
  }
}
