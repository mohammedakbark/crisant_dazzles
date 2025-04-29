import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 4),
            SizedBox(
              width: ResponsiveHelper.wp,
              child: Center(
                child: DefaultTextStyle(
                  style: GoogleFonts.dancingScript(
                    fontSize: 100,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,

                    animatedTexts: [
                      TyperAnimatedText(
                        'hello',
                        speed: Duration(microseconds: 100000),
                      ),
                    ],
                    
                  ),
                ),
              ),
            ),
            Spacer(flex: 3),
            Text("App Version 1.0"),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
