import 'dart:async';
import 'dart:developer';

import 'package:dazzles/module/driver/check%20in/data/model/driver_customer_car_suggession_model.dart';
import 'package:dazzles/module/driver/check%20in/data/model/driver_reg_customer_model.dart';
import 'package:dazzles/module/driver/check%20in/data/provider/driver%20controller/driver_check_in_state.dart';
import 'package:dazzles/module/driver/check%20in/data/repo/driver_recieve_vehicle_repo.dart';
import 'package:dazzles/module/driver/check%20in/data/repo/driver_suggest_customer_repo.dart';
import 'package:dazzles/module/driver/check%20in/data/repo/driver_suggest_customer_vehicles_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverCheckInController
    extends AsyncNotifier<DriverCheckInControllerState> {
  @override
  FutureOr<DriverCheckInControllerState> build() {
    return DriverCheckIninitialState();
  }

  Future<void> showCustomerSuggessions(String mobile) async {
    try {
      state = AsyncValue.loading();

      final response =
          await DriverSuggestCustomerRepo.onSuggestCustomer(mobile);
      if (response['error'] == false) {
        state = AsyncValue.data(DriverCheckInControllerSuccessState(
            suggessionList:
                response['data'] as List<DriverCustomerSuggessionModel>,
            customerVehicleList: [],
            selectedCustomerId: null,
            selectedVehicleId: null));
      } else {
        state = AsyncValue.error(response['data'], StackTrace.empty);
      }
    } catch (e, t) {
      state = AsyncValue.error(e, t);
    }
  }

  Future<void> clearCustokerSuggession() async {
    state = AsyncValue.data(DriverCheckInControllerSuccessState(
        suggessionList: [],
        customerVehicleList: [],
        selectedCustomerId: null,
        selectedVehicleId: null));
  }

  Future<void> showCustomerVehicleSuggession(int customerId) async {
    log(customerId.toString());
    try {
      final response =
          await DriverGetCustomerVehiclesRepo.getCustomerVehicleRepo(
              customerId);
      if (response['error'] == false) {
        state = AsyncValue.data(DriverCheckInControllerSuccessState(
            selectedVehicleId: null,
            customerVehicleList:
                response['data'] as List<DriverCustomerCarSuggessionModel>,
            suggessionList: [],
            selectedCustomerId: customerId));
      } else {
        log(response['data']);
        state = AsyncValue.data(
            DriverCheckInErrorState(errorText: response['data']));
      }
    } catch (e) {
      state = AsyncValue.data(DriverCheckInErrorState(errorText: e.toString()));
    }
  }

  //--------SELECTION---------

  Future<void> onSelectVehicleFromList(int vehicleId) async {
    try {
      if (state.hasValue) {
        final currentState = state.value as DriverCheckInControllerSuccessState;

        state = AsyncValue.data(currentState.copyWith(
          selectedVehicleId: vehicleId,
        ));
      }
    } catch (e) {
      state = AsyncValue.data(DriverCheckInErrorState(errorText: e.toString()));
    }
  }

  Future<void> clearSelectedCar() async {
    try {
      if (state.hasValue) {
        final currentState = state.value as DriverCheckInControllerSuccessState;
        log("message");
        state = AsyncValue.data(DriverCheckInControllerSuccessState(
          suggessionList: [],
          customerVehicleList: currentState.customerVehicleList,
          selectedCustomerId: currentState.selectedCustomerId,
          selectedVehicleId: null,
        ));
      }
    } catch (e) {
      state = AsyncValue.data(DriverCheckInErrorState(errorText: e.toString()));
    }
  }

  // SUBMISSION------------

  Future<bool> onSubmitCustomerRegister(
      String mobileNumber,
      String name,
      String qrId,
      String regNumber,
      String brand,
      String model,
      int? carId,
      int? customerId) async {
    try {
      state = AsyncValue.data(DriverCheckInLoadingState());
      final response = await DriverReceiveVehicleRepo.onReceiveNewVehilce(
          mobileNumber, name, qrId, regNumber, brand, model, carId, customerId);

      if (response['error'] == false) {
        state = AsyncValue.data(DriverCheckInControllerSuccessState(
            suggessionList: [],
            customerVehicleList: [],
            selectedCustomerId: null,
            selectedVehicleId: null));
        return true;
      } else {
        state = AsyncValue.data(
            DriverCheckInErrorState(errorText: response['data']));
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(DriverCheckInErrorState(errorText: e.toString()));
      return false;
    }
  }
}

final driverControllerProvider = AsyncNotifierProvider<DriverCheckInController,
    DriverCheckInControllerState>(DriverCheckInController.new);
