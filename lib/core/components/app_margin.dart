import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppMargin extends StatelessWidget {
  final Widget child;

  const AppMargin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isTab = ResponsiveHelper.isTablet();
    return Padding(padding: EdgeInsets.symmetric(horizontal:isTab?20: 15), child: child);
  }
}
