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
}
