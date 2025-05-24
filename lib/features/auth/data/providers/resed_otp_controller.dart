import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResedOtpController extends AsyncNotifier<Map<String, dynamic>> {
  bool _isEnabledResendOTPButton = false;
  Timer? timer;
  int _start = 60;
  void startTimer() {
    _isEnabledResendOTPButton = false;
    _start = 60;
    state=AsyncValue.data({"start":_start,"isButtonEnables":_isEnabledResendOTPButton});
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _isEnabledResendOTPButton = true;
        timer.cancel();
        state=AsyncValue.data({"start":_start,"isButtonEnables":_isEnabledResendOTPButton});
      } else {
        _start--;
        state=AsyncValue.data({"start":_start,"isButtonEnables":_isEnabledResendOTPButton});
      }
    });
  }

  void dispose() {
    timer?.cancel();
  }

  @override
  FutureOr<Map<String, dynamic>> build() {
    return {};
  }
}

final resendOtpControllerProvider =
    AsyncNotifierProvider<ResedOtpController, Map<String, dynamic>>(
  () => ResedOtpController(),
);
