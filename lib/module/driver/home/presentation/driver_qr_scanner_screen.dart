import 'dart:developer';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/module/driver/home/data/provider/home%20provider/driver_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DriverQRScannerPage extends StatefulWidget {
  final String scanFor;

  const DriverQRScannerPage({super.key, required this.scanFor});

  @override
  State<DriverQRScannerPage> createState() => _DriverQRScannerPageState();
}

class _DriverQRScannerPageState extends State<DriverQRScannerPage> {
  late bool isCheckIn;
  @override
  void initState() {
    super.initState();
    if (widget.scanFor == "checkIn") {
      isCheckIn = true;
    } else {
      isCheckIn = false;
    }
  }

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: AppBackButton(),
          title: Text(
            'Scan QR Code',
            style: AppStyle.boldStyle(),
          )),
      body: MobileScanner(
        // useAppLifecycleState: false,

        placeholderBuilder: (context) => AppLoading(),

        overlayBuilder: (context, constraints) {
          final double width = constraints.maxWidth * 0.7;
          final double height = constraints.maxWidth * 0.7;
          final double borderLength = 30.0;
          final double borderWidth = 5.0;

          return Center(
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  // Top Left
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: borderLength,
                          height: borderWidth,
                          color: AppColors.kTeal,
                        ),
                        Container(
                          width: borderWidth,
                          height: borderLength - borderWidth,
                          color: AppColors.kTeal,
                        ),
                      ],
                    ),
                  ),
                  // Top Right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: borderLength,
                          height: borderWidth,
                          color: AppColors.kTeal,
                        ),
                        Container(
                          width: borderWidth,
                          height: borderLength - borderWidth,
                          color: AppColors.kTeal,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Left
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: borderWidth,
                          height: borderLength - borderWidth,
                          color: AppColors.kTeal,
                        ),
                        Container(
                          width: borderLength,
                          height: borderWidth,
                          color: AppColors.kTeal,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Right
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: borderWidth,
                          height: borderLength - borderWidth,
                          color: AppColors.kTeal,
                        ),
                        Container(
                          width: borderLength,
                          height: borderWidth,
                          color: AppColors.kTeal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        onDetect: (barcodes) async {
          if (_isProcessing) return; // 👈 prevent duplicate triggers
          _isProcessing = true;

          final code = barcodes.barcodes.first.rawValue;
          if (isCheckIn) {
            await onScanCheckIn(code);
          } else {
            await onScanCheckOut(code);
          }

          // Optional: delay before allowing another scan
          await Future.delayed(const Duration(seconds: 2));
          _isProcessing = false;
        },
      ),
    );
  }

  Future<void> onScanCheckIn(String? code) async {
    try {
      if (code != null) {
        HapticFeedback.heavyImpact();
        final qrId = await DriverHomeController.onCheckInScanQrCode(code);

        if (qrId != null) {
          log(qrId);
          // showCustomSnackBarAdptive(message)
          showToastMessage(context, "QrCode Detected.");
          context.pushReplacement(drCustomerRegScreen, extra: {"qrId": qrId});
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        if (context.canPop()) context.pop();
      }
    }
  }

  Future<void> onScanCheckOut(String? code) async {
    try {
      if (code != null) {
        HapticFeedback.heavyImpact();
        final modl = await DriverHomeController.onCheckOutScanQrCode(code);

        if (modl != null) {
          // showCustomSnackBarAdptive(message)
          showToastMessage(context, "QrCode Detected.");
          context.pushReplacement(drlocationScreen,
              extra: {"modelData": modl.toJson()});
        } else {
          if (mounted) {
            if (context.canPop()) context.pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        if (context.canPop()) context.pop();
      }
    }
  }
}
