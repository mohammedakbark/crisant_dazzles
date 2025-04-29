import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                    style: GoogleFonts.libreBaskerville(
                      fontSize: ResponsiveHelper.wp * .15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                  Text(
                    "MYSORE | BANGALORE",
                    style: AppStyle.mediumStyle(
                      color: AppColors.kPrimaryColor,
                      spacing: 4,
                    ),
                  ),
                  AppSpacer(hp: .15),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Enter your email address",
                    validator: AppValidator.emailValidator,
                  ),
                  AppSpacer(hp: .02),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    validator: AppValidator.requiredValidator,
                  ),

                  AppSpacer(hp: .02),

                  AppButton(
                    title: "Login",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                  ),
                  AppSpacer(hp: .1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Lost your password?"),
                      TextButton(onPressed: () {}, child: Text("Reset Now")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
