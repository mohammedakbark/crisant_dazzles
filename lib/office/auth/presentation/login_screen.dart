import 'dart:async';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/validators.dart';
import 'package:dazzles/office/auth/data/providers/login_controller.dart';
import 'package:dazzles/office/auth/data/providers/resed_otp_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static String initialValue = "Office";

  final _userNameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _mobileNumberController = TextEditingController();

  final _pinputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

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

  void _onChangeRole(
    value,
  ) {
    initialValue = value!;
    if (initialValue == LoginController.mainRole) {
      ref.watch(mobileLoginControllerProvider.notifier).state = false;
    } else {
      ref.watch(mobileLoginControllerProvider.notifier).state = true;
    }
    _clearController();
  }

// LOGIN WITH PASSWORD  (FOR OFFICE ___)
  void _loginWithPassword(
    context,
  ) {
    ref.read(loginControllerProvider.notifier).onLogin(
          _userNameController.text.trim(),
          _passwordController.text.trim(),
          initialValue,
          context,
        );
  }

// LOGIN WITH OTP ( FOR OTHER USERS___)
  void _genarateOTPforLogin(
    context,
  ) async {
    final response =
        await ref.read(loginControllerProvider.notifier).loginWithMobileNumber(
              initialValue,
              _mobileNumberController.text.trim(),
              context,
            );

    if (response != null) {
      final id = response['id'] as int;
      final role = response['role'] as String;
      log("id : $id  --  role : $role");
      showOTPSheet(context, id, role);
    }
  }

  void _onVerifyOTP(
    BuildContext context,
    WidgetRef ref,
    int id,
    String role,
  ) async {
    if (_otpFormKey.currentState!.validate()) {
      log("verifying OTP");
      ref.read(loginControllerProvider.notifier).verifyOTP(
            id,
            _pinputController.text.trim(),
            role,
            context,
          );
    }
  }

  void _resendOTP() async {
    log("RESEND OTP TRIGGERD");
    ref.read(resendOtpControllerProvider.notifier).startTimer();
    await ref.read(loginControllerProvider.notifier).loginWithMobileNumber(
          initialValue,
          _mobileNumberController.text.trim(),
          context,
        );
  }

  void _clearController() {
    _mobileNumberController.clear();
    _passwordController.clear();
    _userNameController.clear();
    _pinputController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final isMobileNumberLogin = ref.watch(mobileLoginControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
      ),
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
                      onChanged: (value) => _onChangeRole(
                            value,
                          )),
                  AppSpacer(hp: .02),
//  TEXTFORMFIELD
                  isMobileNumberLogin
                      ? _buildMobileLoginUI()
                      : _buildUserNameLoginUI(),
                  _errorWidgetBuilder(ref),

                  BuildStateManageComponent(
                    stateController: ref.watch(loginControllerProvider),
                    successWidget: (data) => AppButton(
                      title: isMobileNumberLogin ? "GET OTP" : "Login",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (isMobileNumberLogin) {
                            // mobile number with OTP
                            _genarateOTPforLogin(
                              context,
                            );
                          } else {
                            // user name with password
                            _loginWithPassword(
                              context,
                            );
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

  showOTPSheet(BuildContext context, int id, String role) {
    ref.read(resendOtpControllerProvider.notifier).startTimer();

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Consumer(builder: (context, newRef, _) {
              return AnimatedPadding(
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
                        child: Form(
                          key: _otpFormKey,
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
                                errorTextStyle: AppStyle.mediumStyle(color: AppColors.kErrorPrimary),
                                validator: (value) => AppValidator.requiredValidator(value),
                                keyboardType: TextInputType.number,
                                length: 6,
                                controller: _pinputController,
                                defaultPinTheme: _pinTheme,
                                focusedPinTheme: _pinTheme,
                                errorPinTheme: _errorPinThem,
                              ),
                              AppSpacer(hp: .02),
                              _errorWidgetBuilder(newRef),
                              Consumer(builder: (context, reff, child) {
                                final isEnabled = reff
                                    .watch(resendOtpControllerProvider)
                                    .value?["isButtonEnables"];
                                final timer = reff
                                    .watch(resendOtpControllerProvider)
                                    .value!["start"]
                                    .toString();
                          
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Dont't receive the OTP ?",
                                      style: AppStyle.mediumStyle(
                                          color: AppColors.kTextPrimaryColor),
                                    ),
                                    AppSpacer(
                                      wp: .05,
                                    ),
                                    isEnabled
                                        ? InkWell(
                                            onTap: () => _resendOTP(),
                                            child: Text(
                                              "RESEND OTP",
                                              style: AppStyle.boldStyle(
                                                  color:
                                                      AppColors.kPrimaryColor),
                                            ))
                                        : Text(
                                            "00:${timer}",
                                            style: AppStyle.boldStyle(
                                                color: AppColors.kPrimaryColor),
                                          ),
                                  ],
                                );
                              }),
                              AppSpacer(hp: .02),
                              BuildStateManageComponent(
                                stateController:
                                    newRef.watch(loginControllerProvider),
                                successWidget: (data) => AppButton(
                                    title: 'Verify OTP',
                                    onPressed: () => _onVerifyOTP(
                                        context, newRef, id, role)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              );
            }));
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

  final _errorPinThem = PinTheme(
    height: ResponsiveHelper.wp / 9,
    width: ResponsiveHelper.wp / 5,
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.kErrorPrimary,
      ),
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.borderRadiusSmall,
      ),
    ),
  );

  Widget _errorWidgetBuilder(WidgetRef ref) {
    return ref.watch(loginControllerProvider.notifier).showMessage
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  ref.watch(loginControllerProvider.notifier).message ?? '',
                  style: AppStyle.boldStyle(
                      color:
                          ref.watch(loginControllerProvider.notifier).isError ==
                                  true
                              ? AppColors.kErrorPrimary
                              : AppColors.kGreen),
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
