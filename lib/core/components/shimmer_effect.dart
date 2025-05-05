import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  final Widget child;
  const ShimmerEffect({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: child,
    );
  }

  static Widget placeHolder({required double height, required double width}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kBgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      height: height,
      width: width,
    );
  }
}
