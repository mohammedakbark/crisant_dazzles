import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

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
