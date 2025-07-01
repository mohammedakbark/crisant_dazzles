import 'package:dazzles/driver/check%20in/data/model/driver_reg_customer_model.dart';

class DriverCheckInControllerState {
  final List<DriverRegCustomerModel> suggessionList;

  DriverCheckInControllerState({this.suggessionList = const []});
}

class DriverCheckIninitialState extends DriverCheckInControllerState {}

// class DriverCheckInControllerErrorState extends DriverCheckInControllerState {}

// class DriverCheckInControllerLoadingState
//     extends DriverCheckInControllerState {}

class DriverCheckInControllerSuccessState extends DriverCheckInControllerState {
  DriverCheckInControllerSuccessState(
      {required List<DriverRegCustomerModel> suggessionList})
      : super(suggessionList: suggessionList);
}
