import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/utils/permission_hendle.dart';
import 'package:dazzles/module/driver/check%20in/data/model/driver_customer_car_suggession_model.dart';
import 'package:dazzles/module/driver/check%20in/data/model/driver_reg_customer_model.dart';
import 'package:dazzles/module/driver/check%20in/data/provider/driver%20controller/driver_check_in_state.dart';
import 'package:dazzles/module/driver/check%20in/data/repo/driver_recieve_vehicle_repo.dart';
import 'package:dazzles/module/driver/check%20in/data/repo/driver_suggest_customer_repo.dart';
import 'package:dazzles/module/driver/check%20in/data/repo/driver_suggest_customer_vehicles_repo.dart';
import 'package:dazzles/module/driver/check%20in/data/repo/driver_upload_initila_video_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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

  // SUBMISSION.    <------------

// ----vehicle and customer details. (1)
  Future<String?> onSubmitCustomerRegister(
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
            
        return response['data'].toString();
      } else {
        state = AsyncValue.data(
            DriverCheckInErrorState(errorText: response['data']));
        return null;
      }
    } catch (e) {
      state = AsyncValue.data(DriverCheckInErrorState(errorText: e.toString()));
      return null;
    }
  }

  // (2) initla video and location.

  Future<void> _submitVideoAndLocation(
      BuildContext context, String valetId) async {
    log("<------- Video and Location ------>");
    log(_pickedVideoFile!.path);
    log(lat.toString());
    log(lon.toString());
    if (_pickedVideoFile != null && lat != null && lon != null) {
      final respons = await DriverUploadInitilaVideoRepo.onUploadIntilaVideo(
          lat!, lon!, _pickedVideoFile!, valetId);

      if (respons['error'] == false) {
        context.go(drNavScreen);
      } else {
        log(respons['data']);
      }
    }
  }

  // Video Pikcer
  File? _pickedVideoFile;
  double? lat;
  double? lon;
  Future<void> onTakeVideo(BuildContext context, String valetId) async {
    final hasPermission = await AppPermissions.askLocationPermission();

    if (!hasPermission) return null;
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );

    if (pickedFile != null) {
      _pickedVideoFile = File(pickedFile.path);
      final position = await _getCurrentLocation();
      if (position != null) {
        lat = position.latitude;
        lon = position.longitude;

        await _submitVideoAndLocation(context, valetId);
      }
    }
  }

  Future<Position?> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
    ));
  }
}

final driverControllerProvider = AsyncNotifierProvider<DriverCheckInController,
    DriverCheckInControllerState>(DriverCheckInController.new);
