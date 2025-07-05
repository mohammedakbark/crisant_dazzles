import 'dart:async';

import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/module/driver/home/data/provider/home%20provider/driver_home_provider_state.dart';
import 'package:dazzles/module/driver/home/data/repo/driver_qr_code_scan_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverHomeController extends AsyncNotifier<DriverHomeProviderState> {
  @override
  FutureOr<DriverHomeProviderState> build() {
    return DriverHomeProviderState(qrId: "");
  }

  static Future<String?> onScanQrCode(
    String qrCode,
  ) async {
    try {
      final response = await DriverQrCodeScanRepo.onScanQrCode(qrCode);
      if (response['error'] == false) {
        return response['data'];
      } else {
        showCustomSnackBarAdptive(response['data'], isError: true);
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

final qrCodeRedControllerProvider =
    AsyncNotifierProvider<DriverHomeController, DriverHomeProviderState>(
  DriverHomeController.new,
);
