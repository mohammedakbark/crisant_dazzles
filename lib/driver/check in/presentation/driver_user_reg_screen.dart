import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/validators.dart';
import 'package:dazzles/driver/check%20in/data/model/driver_reg_customer_model.dart';
import 'package:dazzles/driver/check%20in/data/provider/driver%20controller/driver_check_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DriverCustomerRegScreen extends StatelessWidget {
  final String qrId;
  DriverCustomerRegScreen({super.key, required this.qrId});

  final _regNumberController = TextEditingController();
  final _customerNameController = TextEditingController();

  final _mobileNumberController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: AppBackButton(),
          title: Text(
            'Customer Registration',
            style: AppStyle.boldStyle(),
          )),
      body: AppMargin(
          child: Form(
        key: _formkey,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                suggessionTextField(),
                AppSpacer(
                  hp: .01,
                ),
                CustomTextField(
                  hintText: "Enter customer name",
                  title: 'Customer Name',
                  controller: _customerNameController,
                  validator: AppValidator.requiredValidator,
                ),
                AppSpacer(
                  hp: .01,
                ),
                CustomTextField(
                  controller: _regNumberController,
                  hintText: "Enter customer vehicle number",
                  title: 'Vehicle Number',
                  validator: AppValidator.vehicleNumberValidator,
                ),
                AppSpacer(
                  hp: .04,
                ),
                Consumer(builder: (context, ref, _) {
                  return _formkey.currentState!.validate() &&
                          ref.watch(driverControllerProvider).isLoading
                      ? AppLoading()
                      : AppButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              await ref
                                  .read(driverControllerProvider.notifier)
                                  .onSubmitCustomerRegister(
                                      _mobileNumberController.text.trim(),
                                      _customerNameController.text.trim(),
                                      qrId,
                                      _regNumberController.text.trim());
                            }
                          },
                          title: "Submit");
                })
              ],
            ),
            _buildSuggessionUi()
          ],
        ),
      )),
    );
  }

  Widget suggessionTextField() {
    return Consumer(builder: (context, ref, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mobile Number", style: AppStyle.boldStyle()),
          AppSpacer(
            hp: .01,
          ),
          TextFormField(
            onChanged: (value) {
              if (value.length >= 4) {
                _debouncer.run(() {
                  ref
                      .read(driverControllerProvider.notifier)
                      .onCheckCustomerSuggession(value);
                });
              } else {
                ref.read(driverControllerProvider.notifier).clearSuggession();
              }
            },
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            validator: AppValidator.mobileNumberValidator,
            keyboardType: TextInputType.number,
            controller: _mobileNumberController,
            cursorColor: AppColors.kPrimaryColor,
            style: AppStyle.mediumStyle(
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
                fillColor: AppColors.kBgColor,
                filled: true,
                suffixIconConstraints: BoxConstraints(maxWidth: 50),
                suffixIcon: ref.watch(driverControllerProvider).isLoading
                    ? AppLoading()
                    : SizedBox.shrink(),
                hintText: "Enter customer mobile number",
                focusedBorder: _border(),
                enabledBorder: _border(),
                errorBorder: _border(error: true),
                focusedErrorBorder: _border(error: true)),
          ),
        ],
      );
    });
  }

  _border({bool? error}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
          color: error == true
              ? AppColors.kErrorPrimary
              : AppColors.kPrimaryColor),
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.borderRadiusSmall,
      ),
    );
  }

  Widget _buildSuggessionUi() {
    return Positioned(
      top: 80,
      left: 2,
      right: 2,
      child: Consumer(
        builder: (context, ref, child) {
          return ref.watch(driverControllerProvider).when(
                data: (state) {
                  List<DriverRegCustomerModel> listOfSuggession =
                      state.suggessionList;

                  return listOfSuggession.isEmpty
                      ? SizedBox.shrink()
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          width: ResponsiveHelper.wp,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 6,
                                    spreadRadius: 10,
                                    color:
                                        AppColors.kPrimaryColor.withAlpha(40))
                              ],
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.kWhite),
                          child: AnimationLimiter(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 375),
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                  // horizontalOffset: 50.0,
                                  verticalOffset: 50,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: listOfSuggession.asMap().entries.map(
                                  (e) {
                                    final value = e.value;
                                    final index = e.key;
                                    return InkWell(
                                      onTap: () {
                                        _mobileNumberController.text =
                                            value.number;
                                        _customerNameController.text =
                                            value.name;

                                        ref
                                            .read(driverControllerProvider
                                                .notifier)
                                            .clearSuggession();
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                value.number,
                                                style: AppStyle.boldStyle(
                                                    color: AppColors.kBgColor),
                                              ),
                                              Text(
                                                value.name,
                                                style: AppStyle.boldStyle(
                                                    color: AppColors.kBgColor),
                                              ),
                                            ],
                                          ),
                                          if (index !=
                                              listOfSuggession.length - 1)
                                            Divider(
                                              color: AppColors.kTextPrimaryColor
                                                  .withAlpha(60),
                                            )
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        );
                },
                error: (error, stackTrace) => Text(
                  error.toString(),
                  style: AppStyle.normalStyle(color: AppColors.kErrorPrimary),
                ),
                loading: () => SizedBox(),
              );
        },
      ),
    );
  }
}
