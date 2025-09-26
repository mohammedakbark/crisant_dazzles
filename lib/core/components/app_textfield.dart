import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final Color? fillColor;
  // final Color? borderColor;
  // final Color? hintColor;
  final TextEditingController? controller;
  final String? hintText;
  final String? labeltext;
  final bool? isObsecure;
  final Widget? prefixIcon;
  final Widget? sufixicon;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;
  final int? maxLenght;
  final int? maxLine;
  final void Function()? onTap;
  final bool? isTextCapital;
  final bool? isReadOnly;
  final void Function(String)? onChanged;
  final bool? isRequired;
  final bool? isOutlineBorder;
  const CustomTextField({
    super.key,
    // this.hintColor,
    // this.borderColor,
    this.onChanged,
    this.isRequired,
    this.title,
    this.isReadOnly,
    this.fillColor,
    this.controller,
    this.hintText,
    this.labeltext,
    this.isObsecure,
    this.prefixIcon,
    this.sufixicon,
    this.keyBoardType,
    this.validator,
    this.maxLenght,
    this.maxLine,
    this.onTap,
    this.isOutlineBorder = true,
    this.isTextCapital,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Column(
                children: [
                  RichText(
                    text: TextSpan(
                        text: title!,
                        style: AppStyle.boldStyle(),
                        children: [
                          if (isRequired == true)
                            TextSpan(
                                text: " *",
                                style: AppStyle.boldStyle(
                                    color: AppColors.kErrorPrimary))
                        ]),
                  ),
                  // Text(title!, style: AppStyle.boldStyle()),
                  AppSpacer(hp: .005),
                ],
              )
            : SizedBox(),
        TextFormField(
          onChanged: onChanged,
          readOnly: isReadOnly ?? false,
          onTap: onTap,
          maxLines: maxLine ?? 1,
          textCapitalization: isTextCapital == null
              ? TextCapitalization.words
              : isTextCapital == true
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
          inputFormatters: maxLenght == null
              ? []
              : [LengthLimitingTextInputFormatter(maxLenght)],
          validator: validator,
          keyboardType: keyBoardType,
          obscureText: isObsecure ?? false,
          obscuringCharacter: '*',
          controller: controller,
          cursorColor: AppColors.kPrimaryColor,
          style: AppStyle.mediumStyle(
              color: isReadOnly == true ? AppColors.kTextPrimaryColor : null,
              fontSize: ResponsiveHelper.isTablet()
                  ? ResponsiveHelper.fontExtraSmall
                  : null),
          decoration: InputDecoration(
              errorStyle: AppStyle.mediumStyle(
                  color: AppColors.kErrorPrimary,
                  fontSize: ResponsiveHelper.isTablet()
                      ? ResponsiveHelper.fontExtraSmall
                      : null),
              hintStyle: AppStyle.mediumStyle(
                fontSize: ResponsiveHelper.isTablet()
                    ? ResponsiveHelper.fontExtraSmall
                    : null,
                color:
                    // hintColor ??
                    AppColors.kTextPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
              suffixIconColor: AppColors.kWhite,
              prefixIconColor: AppColors.kWhite,
              fillColor: fillColor ?? AppColors.kBgColor,
              filled: true,
              suffixIcon: sufixicon,
              prefixIcon: prefixIcon,
              hintText: hintText,
                focusedBorder: _border(),
              enabledBorder: _border(),
              errorBorder: _border(isError: true),
              focusedErrorBorder: _border(isError: true)),
        ),
      ],
    );
  }

  _border({bool? isError}) => isOutlineBorder == true
      ? OutlineInputBorder(
          borderSide: BorderSide(
              color: isError == true
                  ? AppColors.kErrorPrimary
                  : isReadOnly == true
                      ? AppColors.kGrey
                      : AppColors.kWhite),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadiusSmall,
          ),
        )
      : UnderlineInputBorder(
          borderSide: BorderSide(
              color: isError == true
                  ? AppColors.kErrorPrimary
                  : isReadOnly == true
                      ? AppColors.kGrey
                      : AppColors.kWhite),
        );
}
