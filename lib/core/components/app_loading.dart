import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatefulWidget {
  final bool? isTextLoading;
  final bool? removePadding;
  const AppLoading({super.key, this.isTextLoading, this.removePadding});

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          widget.isTextLoading == true
              ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.removePadding == true ? 0 : 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading", style: AppStyle.boldStyle()),
                    DefaultTextStyle(
                      style: AppStyle.boldStyle(),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        totalRepeatCount: 100,
                        animatedTexts: [WavyAnimatedText('...')],
                        isRepeatingAnimation: true,
                      ),
                    ),
                  ],
                ),
              )
         
              : CircularProgressIndicator.adaptive(
                strokeWidth: 1,
                backgroundColor:Platform.isAndroid? AppColors.kFillColor:null,
              ),
    );
  }
}
