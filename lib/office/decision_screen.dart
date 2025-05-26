import 'dart:math';

import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/paint/bubble_paint.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DecisionScreen extends StatelessWidget {
  const DecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppMargin(
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
              BubbleButton(title:  "GUEST USER",subtitle:  "Open as Guest User",onTap: (){
                context.push(webViewScreen);
              }),
              AppSpacer(hp: .02,),
              BubbleButton(title: "DAZZLES",subtitle: "Login as Dazzles staff.",onTap: (){
                 context.push(loginScreen);
              })
            ],
          ),
        )),
      ),
    );
  }

  
}




class BubbleButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const BubbleButton({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<BubbleButton> createState() => _BubbleButtonState();
}

class _BubbleButtonState extends State<BubbleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    ); // Continuous loop

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.kPrimaryColor),
            ),
            child: ListTile(
              title: Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text(widget.subtitle),
              trailing: Icon(CupertinoIcons.arrow_right_circle),
            ),
          ),
        ],
      ),
    );
  }
}



