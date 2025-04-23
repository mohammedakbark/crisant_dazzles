import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AppSpacer extends StatelessWidget {
  final double? wp;
  final double? hp;

  const AppSpacer({super.key, this.wp, this.hp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wp != null ? ResponsiveHelper.wp * wp : null,
      height: hp != null ? ResponsiveHelper.hp * hp : null,
    );
  }
}
