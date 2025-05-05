import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatefulWidget {
  final bool? isTextLoading;
  final bool? removePadding;
  AppLoading({super.key, this.isTextLoading, this.removePadding});

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {
  // double begin = 0;

  // double end = 1;

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
              // ? TweenAnimationBuilder(
              //   onEnd: () {
              //     setState(() {
              //       final temp = begin;
              //       begin = end;
              //       end = temp;
              //     });
              //   },
              //   duration: Duration(milliseconds: 2000),
              //   tween: Tween<double>(begin: begin, end: end),
              //   curve: Curves.easeInOut,
              //   builder: (context, value, child) {
              //     return Transform.translate(
              //       offset: Offset(0, value * 20),
              //       // : value,
              //       child: Padding(
              //         padding: const EdgeInsets.all(20),
              //         child: Text("Loading...", style: AppStyle.boldStyle()),
              //       ),
              //     );
              //   },
              // )
              : CircularProgressIndicator.adaptive(),
    );
  }
}
