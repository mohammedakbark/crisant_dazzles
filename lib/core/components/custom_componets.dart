import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildIdBadge(
  BuildContext context,
  String id, {
  bool enableCopy = false,
}) {
  return InkWell(
    onTap: () async {
      await Clipboard.setData(ClipboardData(text: id));
      showToastMessage(context, "$id added to clipboard");
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.kErrorPrimary.withAlpha(100),
      ),
      child: Row(
        children: [
          Text(id,
              style: AppStyle.boldStyle(
                color: AppColors.kWhite,
                fontSize: ResponsiveHelper.isTablet() ? ResponsiveHelper.fontExtraSmall : null,
              )),
          AppSpacer(wp: .01),
          enableCopy
              ? Icon(
                  size: ResponsiveHelper.isTablet() ? 30 : 14,
                  Icons.copy,
                  color: AppColors.kWhite)
              : SizedBox(),
        ],
      ),
    ),
  );
}
