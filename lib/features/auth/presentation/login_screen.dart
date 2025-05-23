import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/validators.dart';
import 'package:dazzles/features/auth/data/providers/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _pinputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final team = [
    'Office',
    'Sales',
    'Support',
    'Supervisor',
    'Stylist',
    'Catalyst',
    'Tailor',
    'Master'
  ];
  static String initialValue = "Office";

  void _onChangeRole(value, WidgetRef ref) {
    initialValue = value!;
    if (initialValue == LoginController.mainRole) {
      ref.watch(mobileLoginControllerProvider.notifier).state = false;
    } else {
      ref.watch(mobileLoginControllerProvider.notifier).state = true;
    }
    _clearController();
  }

  void _loginWithPassword(context, WidgetRef ref) {
    ref.read(loginControllerProvider.notifier).onLogin(
          _userNameController.text.trim(),
          _passwordController.text.trim(),
          initialValue,
          context,
        );
  }

  void _loginWithMobileNumber(context, WidgetRef ref) {
    ref.read(loginControllerProvider.notifier).loginWithMobileNumber(
          initialValue,
          _mobileNumberController.text.trim(),
          showOTPSheet(context,ref),
          context,
        );
  }

  void _onVerifyOTP() {}

  void _clearController() {
    _mobileNumberController.clear();
    _passwordController.clear();
    _userNameController.clear();
    _pinputController.clear();
  }

  @override
  Widget build(BuildContext context, ref) {
    final isMobileNumberLogin = ref.watch(mobileLoginControllerProvider);

    return Scaffold(
      body: Center(
        child: AppMargin(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "DAZZLES",
                    style: GoogleFonts.roboto(
                      fontSize: ResponsiveHelper.wp * .15,
                      fontWeight: FontWeight.w100,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  Text(
                    "MYSORE | BANGALORE",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w100,
                      color: AppColors.kPrimaryColor,
                      fontSize: ResponsiveHelper.wp * .04,
                      letterSpacing: 4,
                    ),
                  ),
                  AppSpacer(hp: .15),
                  DropdownButtonFormField(
                      value: initialValue,
                      decoration: InputDecoration(
                        errorStyle: AppStyle.mediumStyle(
                            color: AppColors.kErrorPrimary),
                        hintStyle: AppStyle.mediumStyle(
                          color:
                              // hintColor ??
                              AppColors.kTextPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        suffixIconColor: AppColors.kWhite,
                        prefixIconColor: AppColors.kWhite,
                        fillColor: AppColors.kBgColor,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                // borderColor ??
                                AppColors.kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadiusSmall,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                // borderColor ??
                                AppColors.kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadiusSmall,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.kErrorPrimary),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadiusSmall,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.kErrorPrimary),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadiusSmall,
                          ),
                        ),
                      ),
                      items: team
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) => _onChangeRole(value, ref)),
                  AppSpacer(hp: .02),
//  TEXTFORMFIELD
                  isMobileNumberLogin
                      ? _buildMobileLoginUI()
                      : _buildUserNameLoginUI(),

                  BuildStateManageComponent(
                    stateController: ref.watch(loginControllerProvider),
                    successWidget: (data) => AppButton(
                      title: isMobileNumberLogin ? "GET OTP" : "Login",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (isMobileNumberLogin) {
                            // mobile number with OTP
                            _loginWithMobileNumber(context, ref);
                          } else {
                            // user name with password
                            _loginWithPassword(context, ref);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLoginUI() => Column(
        children: [
          CustomTextField(
            controller: _mobileNumberController,
            hintText: "Mobile Number",
            maxLenght: 10,
            validator: AppValidator.mobileNumberValidator,
          ),
          AppSpacer(hp: .02),
        ],
      );
  Widget _buildUserNameLoginUI() => Column(
        children: [
          CustomTextField(
            controller: _userNameController,
            hintText: "User Name",
            validator: AppValidator.requiredValidator,
          ),
          AppSpacer(hp: .02),
          Consumer(builder: (context, ref, _) {
            return CustomTextField(
              isObsecure: ref.watch(passwordObsecureControllerProvider),
              sufixicon: InkWell(
                  onTap: () {
                    if (ref.read(passwordObsecureControllerProvider) == false) {
                      ref
                          .read(passwordObsecureControllerProvider.notifier)
                          .state = true;
                    } else {
                      ref
                          .read(passwordObsecureControllerProvider.notifier)
                          .state = false;
                    }
                  },
                  child: Icon(ref.watch(passwordObsecureControllerProvider)
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash)),
              controller: _passwordController,
              hintText: "Password",
              validator: AppValidator.requiredValidator,
            );
          }),
          AppSpacer(hp: .02),
        ],
      );

  showOTPSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AnimatedPadding(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SlideInUp(
                  duration: Duration(milliseconds: 400),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.kBgColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SlideInUp(
                      duration: Duration(milliseconds: 800),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text("OTP Verification",
                          //     style: AppStyle.boldStyle(
                          //         fontSize: ResponsiveHelper.fontLarge)),
                          AppSpacer(
                            hp: .01,
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Enter the OTP sent to ",
                                children: [
                                  TextSpan(
                                      style: AppStyle.largeStyle(),
                                      text:
                                          "+91 ${_mobileNumberController.text}")
                                ]),
                          ),
                          AppSpacer(hp: .02),
                          Pinput(
                            keyboardType: TextInputType.number,
                            length: 6,
                            controller: _pinputController,
                            defaultPinTheme: _pinTheme,
                            focusedPinTheme: _pinTheme,
                          ),
                          AppSpacer(hp: .02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Dont't receive the OTP ?"),
                              TextButton(
                                  onPressed: () {}, child: Text("RESEND OTP")),
                            ],
                          ),
                          AppSpacer(hp: .02),
                          BuildStateManageComponent(
                            stateController: ref.watch(loginControllerProvider),
                            successWidget: (data) => AppButton(
                              title: 'Verify OTP',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _onVerifyOTP();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ));
  }

  final _pinTheme = PinTheme(
    height: ResponsiveHelper.wp / 9,
    width: ResponsiveHelper.wp / 5,
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.kPrimaryColor,
      ),
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.borderRadiusSmall,
      ),
    ),
  );
}
