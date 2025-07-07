import 'package:dazzles/module/driver/check%20in/data/model/driver_customer_car_suggession_model.dart';
import 'package:dazzles/module/driver/check%20in/data/model/driver_reg_customer_model.dart';

class DriverCheckInControllerState {
  final int? selectedCustomerId;
  final int? selectedVehicleId;

  DriverCheckInControllerState(
      {this.selectedCustomerId,
      this.selectedVehicleId,
      });
}

class DriverCheckIninitialState extends DriverCheckInControllerState {}

class DriverCheckInLoadingState extends DriverCheckInControllerState {}

class DriverCheckInUploadVideoLoadingState extends DriverCheckInControllerState {}

class DriverCheckInErrorState extends DriverCheckInControllerState {
  final String errorText;

  DriverCheckInErrorState({required this.errorText});
}

class DriverCheckInControllerSuccessState extends DriverCheckInControllerState {
  final List<DriverCustomerSuggessionModel> suggessionList;
  final List<DriverCustomerCarSuggessionModel> customerVehicleList;

  DriverCheckInControllerSuccessState(
      {required this.customerVehicleList,
      super.selectedCustomerId,
      super.selectedVehicleId,
      required this.suggessionList,
    });

  DriverCheckInControllerSuccessState copyWith(
      {List<DriverCustomerSuggessionModel>? suggessionList,
      List<DriverCustomerCarSuggessionModel>? customerVehicleList,
      int? selectedCustomerId,
      int? selectedVehicleId,
      bool? isLoadingVideoUpload}) {
    return DriverCheckInControllerSuccessState(
      
        selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
        customerVehicleList: customerVehicleList ?? this.customerVehicleList,
        selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
        suggessionList: suggessionList ?? this.suggessionList);
  }
}
