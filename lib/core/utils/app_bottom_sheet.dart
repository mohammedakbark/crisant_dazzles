import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/shared/routes/route_provider.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';

void showCustomBottomSheet(
    {required String message,
    required String buttonText,
    Future<void> Function()? onNext,
    String? skipText,
    VoidCallback? onSkip,
    bool isError = false,
    bool enableHapticFeedback = true,
    Duration animationDuration = const Duration(milliseconds: 350),
    String? subtitle,
    Widget? customIcon,
    Color? primaryColor,
    Color? backgroundColor,
    bool showCloseButton = false,
    EdgeInsets? customPadding,
    bool isLoading = false,
    bool hideIcon = false}) {
  // Trigger haptic feedback
  if (enableHapticFeedback) {
    HapticFeedback.lightImpact();
  }

  // Define colors based on state
  final Color effectivePrimaryColor = primaryColor ??
      (isError ? const Color(0xFFE53E3E) : const Color(0xFF38A169));

  final Color effectiveBackgroundColor = backgroundColor ?? Colors.white;

  showModalBottomSheet(
      isDismissible:
          hideIcon, // Prevent dismissal for errors unless explicitly handled
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: rootNavigatorKey.currentContext!,
      enableDrag: !isError,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                (customPadding?.bottom ?? 24),
            left: customPadding?.left ?? 16,
            right: customPadding?.right ?? 16,
          ),
          child: SlideInUp(
            duration: animationDuration,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  width: 1.5,
                  color: effectivePrimaryColor.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: effectivePrimaryColor.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top handle indicator
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    height: 4,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with close button
                        if (showCloseButton)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close, size: 24),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  foregroundColor: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                        if (hideIcon == false) // Animated Icon
                          BounceInDown(
                            duration: Duration(
                                milliseconds:
                                    animationDuration.inMilliseconds + 100),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: effectivePrimaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: customIcon ??
                                  Icon(
                                    isError
                                        ? Icons.error_outline_rounded
                                        : Icons.check_circle_outline_rounded,
                                    size: 48,
                                    color: effectivePrimaryColor,
                                  ),
                            ),
                          ),
                        if (hideIcon == false) const SizedBox(height: 20),
                        if (hideIcon == false)
                          // Title with enhanced animation
                          FadeInUp(
                            duration: Duration(
                                milliseconds:
                                    animationDuration.inMilliseconds + 200),
                            child: Text(
                              isError ? "Oops!" : "Success!",
                              style: AppStyle.boldStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: effectivePrimaryColor,
                              ),
                            ),
                          ),
                        if (hideIcon == false) const SizedBox(height: 12),

                        // Message
                        FadeInUp(
                          duration: Duration(
                              milliseconds:
                                  animationDuration.inMilliseconds + 300),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: AppStyle.mediumStyle(
                              fontSize: 16,
                              color: AppColors.kBgColor,
                              height: 1.4,
                            ),
                          ),
                        ),

                        // Subtitle if provided
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          FadeInUp(
                            duration: Duration(
                                milliseconds:
                                    animationDuration.inMilliseconds + 400),
                            child: Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: AppStyle.mediumStyle(
                                fontSize: 14,
                                color: AppColors.kBgColor.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Enhanced Button Section
                        FadeInUp(
                          duration: Duration(
                              milliseconds:
                                  animationDuration.inMilliseconds + 500),
                          child: _buildButtonSection(
                            isLoading: isLoading,
                            context: context,
                            buttonText: buttonText,
                            skipText: skipText,
                            onNext: onNext,
                            onSkip: onSkip,
                            primaryColor: effectivePrimaryColor,
                            enableHapticFeedback: enableHapticFeedback,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Widget _buildButtonSection({
  bool isLoading = false,
  required BuildContext context,
  required String buttonText,
  String? skipText,
  Future<void> Function()? onNext,
  VoidCallback? onSkip,
  required Color primaryColor,
  required bool enableHapticFeedback,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Primary Action Button
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ).copyWith(
            overlayColor: MaterialStateProperty.all(
              Colors.white.withOpacity(0.1),
            ),
          ),
          onPressed: () async {
            if (isLoading == false) {
              if (enableHapticFeedback) {
                HapticFeedback.mediumImpact();
              }

              if (onNext != null) await onNext();
              Navigator.pop(context);
            }
          },
          child: isLoading
              ? AppLoading()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: AppStyle.boldStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      color: Colors.white,
                      Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                  ],
                ),
        ),
      ),

      // Skip/Secondary Button
      if (skipText != null) ...[
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: primaryColor.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                primaryColor.withOpacity(0.1),
              ),
            ),
            onPressed: () {
              if (enableHapticFeedback) {
                HapticFeedback.lightImpact();
              }
              Navigator.pop(context);
              if (onSkip != null) onSkip();
            },
            child: Text(
              skipText,
              style: AppStyle.mediumStyle(
                color: primaryColor.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ],
  );
}
