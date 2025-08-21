import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dazzles/core/shared/routes/route_provider.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solar_icons/solar_icons.dart';

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
    backgroundColor: isError == null
        ? AppColors.kFillColor
        : isError == false
            ? AppColors.kGreen.withOpacity(.6)
            : AppColors.kErrorPrimary.withOpacity(.6),
    textColor: AppColors.kWhite,
    fontSize: ResponsiveHelper.fontSmall,
  );
}

showCustomSnackBarAdptive(
  String message, {
  bool? isError,
  Color? color,
}) {
  
  final snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      elevation: 10,
      closeIconColor: AppColors.kWhite,
      margin: EdgeInsets.only(
        left: ResponsiveHelper.wp * .03,
        right: ResponsiveHelper.wp * .03,
        bottom: Platform.isAndroid
            ? ResponsiveHelper.hp * .07
            : ResponsiveHelper.hp * .09,
      ),
      backgroundColor: isError == true
          ? AppColors.kErrorPrimary
          : isError == false
              ? AppColors.kGreen
              : AppColors.kFillColor,
      content: Text(
        message,
        style: AppStyle.normalStyle(color: AppColors.kWhite),
      ));
  ScaffoldMessenger.of(rootNavigatorKey.currentContext!)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackbar);
}

void showCustomDialog({
  required String message,
  required String buttonText,
  VoidCallback? onNext,
  String? skipText,
  VoidCallback? onSkip,
  bool isError = false,
}) {
  showDialog(
    context: rootNavigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError ? Colors.red : Colors.green,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                isError ? "Oops!" : "Success!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isError ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: skipText != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (skipText != null)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onSkip != null) onSkip();
                      },
                      child: Text(skipText),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onNext != null) onNext();
                    },
                    child: Text(buttonText),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


