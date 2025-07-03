import 'dart:developer';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/validators.dart';
import 'package:dazzles/module/driver/check%20in/data/model/driver_customer_car_suggession_model.dart';
import 'package:dazzles/module/driver/check%20in/data/model/driver_reg_customer_model.dart';
import 'package:dazzles/module/driver/check%20in/data/provider/driver%20controller/driver_check_in_controller.dart';
import 'package:dazzles/module/driver/check%20in/data/provider/driver%20controller/driver_check_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class DriverCustomerRegScreen extends ConsumerStatefulWidget {
  final String qrId;
  DriverCustomerRegScreen({super.key, required this.qrId});

  @override
  ConsumerState<DriverCustomerRegScreen> createState() =>
      _DriverCustomerRegScreenState();
}

class _DriverCustomerRegScreenState
    extends ConsumerState<DriverCustomerRegScreen> {
  final _regNumberController = TextEditingController();

  final _customerNameController = TextEditingController();

  final _mobileNumberController = TextEditingController();

  final _brandController = TextEditingController();

  final _modelController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        ref.invalidate(driverControllerProvider);
      },
    );
  }

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
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildForms(),
                  AppSpacer(
                    hp: .02,
                  ),
                  ref.watch(driverControllerProvider).when(
                        data: (state) {
                          if (state is DriverCheckInErrorState) {
                            return Text(
                              state.errorText,
                              style: AppStyle.boldStyle(
                                  color: AppColors.kErrorPrimary),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                        error: (error, stackTrace) => Text(
                          error.toString(),
                          style: AppStyle.boldStyle(
                              color: AppColors.kErrorPrimary),
                        ),
                        loading: () => SizedBox.shrink(),
                      ),
                  AppSpacer(
                    hp: .02,
                  ),
                  _widgetSubmitButton(),
                ],
              ),
            ),
            _buildSuggessionUi()
          ],
        ),
      )),
    );
  }

  Widget _buildForms() {
    return Column(
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
          onChanged: (p0) {
            ref.watch(driverControllerProvider.notifier).clearSelectedCar();
          },
          controller: _regNumberController,
          hintText: "Enter customer vehicle number",
          title: 'Vehicle Number',
          sufixicon: PopupMenuButton<DriverCustomerCarSuggessionModel>(
            icon: Icon(SolarIconsBold.altArrowDown),
            onSelected: (vehcile) async {
              int vehicleId = vehcile.id;
              _modelController.text = vehcile.model;
              _brandController.text = vehcile.brand;
              _regNumberController.text = vehcile.vehicleNumber;

              // ---
              await ref
                  .read(driverControllerProvider.notifier)
                  .onSelectVehicleFromList(vehicleId);
            },
            itemBuilder: (context) => ref.watch(driverControllerProvider).when(
                  data: (state) {
                    if (state is DriverCheckInControllerSuccessState) {
                      return state.customerVehicleList
                          .map(
                            (vehicleInfo) => PopupMenuItem(
                                value: vehicleInfo,
                                child: Text(vehicleInfo.vehicleNumber)),
                          )
                          .toList();
                    } else {
                      return [];
                    }
                  },
                  error: (error, stackTrace) => [],
                  loading: () => [],
                ),
          ),
          validator: AppValidator.vehicleNumberValidator,
        ),
        AppSpacer(
          hp: .01,
        ),
        CustomTextField(
          isReadOnly:
              ref.watch(driverControllerProvider).value?.selectedVehicleId !=
                  null,
          hintText: "Enter vehicle brand name",
          title: 'Brand',
          controller: _brandController,
          validator: AppValidator.requiredValidator,
        ),
        AppSpacer(
          hp: .01,
        ),
        CustomTextField(
          isReadOnly:
              ref.watch(driverControllerProvider).value?.selectedVehicleId !=
                  null,
          hintText: "Enter vehicle model name",
          title: 'Model',
          controller: _modelController,
          validator: AppValidator.requiredValidator,
        ),
      ],
    );
  }

  Widget _widgetSubmitButton() {
    return ref.watch(driverControllerProvider).when(
        skipError: true,
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (state) {
          switch (state) {
            case DriverCheckInLoadingState():
              {
                return AppLoading();
              }
            default:
              {
                return AppButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        final state = ref.read(driverControllerProvider).value;
                        int? customerId = state?.selectedCustomerId;
                        int? vehicleId = state?.selectedVehicleId;
                        log("CustomerId is ${customerId}");
                        log("vehicle Id is ${vehicleId}");
                        final valetId = await ref
                            .read(driverControllerProvider.notifier)
                            .onSubmitCustomerRegister(
                                _mobileNumberController.text.trim(),
                                _customerNameController.text.trim(),
                                widget.qrId,
                                _regNumberController.text.trim(),
                                _brandController.text.trim(),
                                _modelController.text.trim(),
                                vehicleId,
                                customerId);

                        if (valetId != null) {
                          log(" ----  Valet Id is $valetId ----- >");
                          _customerNameController.clear();
                          _mobileNumberController.clear();
                          _regNumberController.clear();
                          _brandController.clear();
                          _modelController.clear();
                          await DriverCheckInController()
                              .onTakeVideo(context, valetId);
                        }
                      }

                      // context.push(drVehicleInfoFormScreen);
                    },
                    title: "Submit");
              }
          }
        },
        error: (error, stackTrace) => SizedBox.shrink(),
        loading: () => SizedBox.shrink());
  }

  Widget suggessionTextField() {
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
                    .showCustomerSuggessions(value);
              });
            } else {
              ref
                  .read(driverControllerProvider.notifier)
                  .clearCustokerSuggession();
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
      child: ref.watch(driverControllerProvider).when(
            data: (state) {
              switch (state) {
                case DriverCheckInControllerSuccessState():
                  {
                    List<DriverCustomerSuggessionModel> listOfSuggession =
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
                                children:
                                    AnimationConfiguration.toStaggeredList(
                                  duration: const Duration(milliseconds: 375),
                                  childAnimationBuilder: (widget) =>
                                      SlideAnimation(
                                    // horizontalOffset: 50.0,
                                    verticalOffset: 50,
                                    child: FadeInAnimation(
                                      child: widget,
                                    ),
                                  ),
                                  children:
                                      listOfSuggession.asMap().entries.map(
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
                                              .showCustomerVehicleSuggession(
                                                  value.id);
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  value.number,
                                                  style: AppStyle.boldStyle(
                                                      color:
                                                          AppColors.kBgColor),
                                                ),
                                                Text(
                                                  value.name,
                                                  style: AppStyle.boldStyle(
                                                      color:
                                                          AppColors.kBgColor),
                                                ),
                                              ],
                                            ),
                                            if (index !=
                                                listOfSuggession.length - 1)
                                              Divider(
                                                color: AppColors
                                                    .kTextPrimaryColor
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
                  }

                default:
                  {
                    return SizedBox();
                  }
              }
            },
            error: (error, stackTrace) => SizedBox.shrink(),
            loading: () => SizedBox(),
          ),
    );
  }
}
