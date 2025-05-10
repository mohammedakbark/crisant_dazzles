import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showCustomSnackBar(
  BuildContext context, {
  String? title,
  ContentType? contentType,
  required String content,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,

    content: AwesomeSnackbarContent(
      title: title ?? '',
      message: content,
      contentType: contentType ?? ContentType.success,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

showToastMessage(
  BuildContext context,
  String message, {
  bool? isError,
  Color? color,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor:
        isError == null
            ? AppColors.kFillColor
            : isError == false
            ? AppColors.kGreen.withOpacity(.6)
            : AppColors.kErrorPrimary.withOpacity(.6),
    textColor: AppColors.kWhite,
    fontSize: ResponsiveHelper.fontSmall,
  );
}
