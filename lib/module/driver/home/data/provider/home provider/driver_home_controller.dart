import 'dart:async';

import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/module/driver/home/data/model/dr_check_out_valet_info_model.dart';
import 'package:dazzles/module/driver/home/data/provider/home%20provider/driver_home_provider_state.dart';
import 'package:dazzles/module/driver/home/data/repo/driver_check_in__qr_code_scan_repo.dart';
import 'package:dazzles/module/driver/home/data/repo/driver_check_out_qr_scan_repo.dart';
import 'package:dazzles/module/driver/home/data/repo/driver_dashboard_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverHomeController extends AsyncNotifier<DriverHomeProviderState?> {
  @override
  FutureOr<DriverHomeProviderState?> build() async {
    return await onFetchDashboard();
  }

  Future<DriverHomeProviderState?> onFetchDashboard() async {
    try {
      state = AsyncValue.loading();
      final resp = await DriverDashboardRepo.onFetchDriverDashboardData();
      if (resp['error'] == false) {
        final data = DriverHomeProviderState(
            totalCheckIn: resp['data']['totalparked'],
            totalCheckOut: resp['data']['totaldelivered']);
        state = AsyncValue.data(data);
        return data;
      } else {
        state = AsyncValue.error(resp['data'], StackTrace.empty);
        return null;
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return null;
    }
  }

  static Future<String?> onCheckInScanQrCode(
    String qrCode,
  ) async {
    try {
      final response = await DriverCheckInQrScanRepo.onScanQrCode(qrCode);
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

  static Future<DrCheckOutValetInfoModel?> onCheckOutScanQrCode(
    String qrCode,
  ) async {
    try {
      final response = await DriverCheckOutQrScanRepo.onScanQrCode(qrCode);
      if (response['error'] == false) {
        return DrCheckOutValetInfoModel.fromJson(response['data']);
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
    AsyncNotifierProvider<DriverHomeController, DriverHomeProviderState?>(
  DriverHomeController.new,
);
