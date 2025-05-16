import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late double _screenWidth;
  static late double _screenHight;

  static get hp => _screenHight;
  static get wp => _screenWidth;

  /// Initialize once using a context (call this in main screen)
  static void init(BuildContext context) {
   
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHight = MediaQuery.of(context).size.height;
  }

  // Padding values (adjusting based on screen width)
  static double get paddingSmall => _screenWidth * 0.02; // ~8px on 400px screen
  static double get paddingMedium => _screenWidth * 0.04; // ~16px
  static double get paddingLarge => _screenWidth * 0.06; // ~24px

  // Font sizes (scaling based on width)
  static double get fontExtraSmall => _screenWidth * 0.025; // ~10px
  static double get fontSmall => _screenWidth * 0.03; // ~14px
  static double get fontMedium => _screenWidth * 0.045; // ~16px
  static double get fontRegular => _screenWidth * 0.05; // ~18px
  static double get fontLarge => _screenWidth * 0.055; // ~20px
  static double get fontXLarge => _screenWidth * 0.07; // ~28px

  // Border Radius (adjusting based on screen width)
  static double get borderRadiusSmall => _screenWidth * 0.02; // ~8px
  static double get borderRadiusMedium => _screenWidth * 0.04; // ~16px
  static double get borderRadiusLarge => _screenWidth * 0.06; // ~24px
}
