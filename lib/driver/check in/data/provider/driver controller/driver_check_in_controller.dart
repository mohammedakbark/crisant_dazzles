import 'dart:async';

import 'package:dazzles/driver/check%20in/data/model/driver_reg_customer_model.dart';
import 'package:dazzles/driver/check%20in/data/provider/driver%20controller/driver_check_in_state.dart';
import 'package:dazzles/driver/check%20in/data/repo/driver_recieve_vehicle_repo.dart';
import 'package:dazzles/driver/check%20in/data/repo/driver_suggest_customer_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverCheckInController
    extends AsyncNotifier<DriverCheckInControllerState> {
  @override
  FutureOr<DriverCheckInControllerState> build() {
    return DriverCheckIninitialState();
  }

  Future<void> onCheckCustomerSuggession(String mobileNumber) async {
    try {
      state = AsyncValue.loading();
      final response =
          await DriverSuggestCustomerRepo.onSuggestCustomer(mobileNumber);
      if (response['error'] == false) {
        final list = response['data'] as List<DriverRegCustomerModel>;

        state = AsyncValue.data(
            DriverCheckInControllerSuccessState(suggessionList: list));
      } else {
        state = AsyncValue.error(response['data'], StackTrace.empty);
      }
    } catch (e, t) {
      state = AsyncValue.error(e, t);
    }
  }

  Future<void> clearSuggession() async {
    state = AsyncValue.data(
        DriverCheckInControllerSuccessState(suggessionList: []));
  }


  Future<void> onSubmitCustomerRegister(
      String mobileNumber, String name, String qrId, String regNumber) async {
    try {
      state = AsyncValue.loading();
      final response = await DriverReceiveVehicleRepo.onReceiveNewVehilce(
          mobileNumber, name, qrId, regNumber);

      if (response['error'] == false) {
        state = AsyncValue.data(
            DriverCheckInControllerSuccessState(suggessionList: []));
      } else {
        state = AsyncValue.error(response['data'], StackTrace.empty);
      }
    } catch (e, t) {}
  }
}

final driverControllerProvider = AsyncNotifierProvider<DriverCheckInController,
    DriverCheckInControllerState>(DriverCheckInController.new);
