import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/module/common/scan%20product/data/provider/scanner_product_detail_contoller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// ignore: must_be_immutable
class QrScanScreen extends ConsumerStatefulWidget {
  QrScanScreen({super.key});

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 40,
        leading: AppBackButton(),
        title: Row(
          children: [
            Icon(CupertinoIcons.qrcode_viewfinder),
            AppSpacer(
              wp: .03,
            ),
            Text("Scan Product QR")
          ],
        ),
      ),
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
                          color: AppColors.kDeepPurple,
                        ),
                        Container(
                          width: borderWidth,
                          height: borderLength - borderWidth,
                          color: AppColors.kDeepPurple,
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
                          color: AppColors.kDeepPurple,
                        ),
                        Container(
                          width: borderWidth,
                          height: borderLength - borderWidth,
                          color: AppColors.kDeepPurple,
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
                          color: AppColors.kDeepPurple,
                        ),
                        Container(
                          width: borderLength,
                          height: borderWidth,
                          color: AppColors.kDeepPurple,
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
                          color: AppColors.kDeepPurple,
                        ),
                        Container(
                          width: borderLength,
                          height: borderWidth,
                          color: AppColors.kDeepPurple,
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
          await onScanQr(code);
          // Optional: delay before allowing another scan
          await Future.delayed(const Duration(seconds: 2));
          _isProcessing = false;
        },
      ),
    );
  }

  Future<void> onScanQr(String? code) async {
    try {
      if (code != null) {
        ref.read(scannerProductDetailProvider(
            {"context": context, "productId": code}).future);
      }
    } catch (e) {
      if (mounted) {
        if (context.canPop()) context.pop();
      }
    }
  }
}
