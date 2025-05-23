// import 'package:dazzles/core/components/app_back_button.dart';
// import 'package:dazzles/core/components/app_button.dart';
// import 'package:dazzles/core/components/app_margin.dart';
// import 'package:dazzles/core/components/app_spacer.dart';
// import 'package:dazzles/core/components/build_state_manage_button.dart';
// import 'package:dazzles/core/shared/theme/app_colors.dart';
// import 'package:dazzles/core/shared/theme/styles/text_style.dart';
// import 'package:dazzles/core/utils/responsive_helper.dart';
// import 'package:dazzles/features/auth/data/providers/login_controller.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';

// class OtpScreen extends ConsumerWidget {
//   final String mobileNumber;
//   final String role;
//   OtpScreen({super.key, required this.mobileNumber, required this.role});
//   final _formKey = GlobalKey<FormState>();
//   final _pinputController = TextEditingController();

//   @override
//   Widget build(BuildContext context, ref) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: AppBackButton(),
//       ),
//       body: Center(
//         child: AppMargin(
//             child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [

//                       // Icon(CupertinoIcons.lock_fill
//                       // ,color: AppColors.kDeepPurple,),
//                       // Text(
//                       //   "DAZZLES",
//                       //   style: GoogleFonts.roboto(
//                       //     fontSize: ResponsiveHelper.wp * .15,
//                       //     fontWeight: FontWeight.w100,
//                       //     color: AppColors.kPrimaryColor,
//                       //   ),
//                       // ),
//                       // Text(
//                       //   "MYSORE | BANGALORE",
//                       //   style: GoogleFonts.roboto(
//                       //     fontWeight: FontWeight.w100,
//                       //     color: AppColors.kPrimaryColor,
//                       //     fontSize: ResponsiveHelper.wp * .04,
//                       //     letterSpacing: 4,
//                       //   ),
//                       // ),
//                       // AppSpacer(hp: .15),
//                       Text("OTP Verification",
//                           style: AppStyle.largeStyle(
//                               fontSize: ResponsiveHelper.fontLarge)),
//                       RichText(text: TextSpan(text: "Enter the OTP sent to ",children: [
//                         TextSpan(
//                           style: AppStyle.largeStyle(),
//                           text: "+91 ${mobileNumber}"
//                         )
//                       ]),),
//                       AppSpacer(hp: .15),
//                       Pinput(
//                         keyboardType: TextInputType.number,
//                         length: 6,
//                         controller: _pinputController,
//                       ),
//                       AppSpacer(hp: .02),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                         Text("Dont't receive the OTP ?"),
//                         TextButton(onPressed: (){}, child: Text("RESEND OTP"))
//                       ],),
//                                             AppSpacer(hp: .02),

//                       BuildStateManageComponent(
//                         stateController: ref.watch(loginControllerProvider),
//                         successWidget: (data) => AppButton(
//                           title: 'Verify OTP',
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {}
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ))),
//       ),
//     );
//   }
// }
