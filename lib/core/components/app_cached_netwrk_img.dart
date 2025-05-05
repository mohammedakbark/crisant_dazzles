import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class AppCachedNetwrkImg extends StatelessWidget {
  final String imagePath;
  const AppCachedNetwrkImg({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorListener: (value) {},
      errorWidget:
          (context, url, error) => Icon(SolarIconsOutline.stickerCircle),
      imageUrl: imagePath,
    );
  }
}
