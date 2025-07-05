import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';

class MyParkedCarState {
  final List<DriverParkedCarModel> parkedCarList;
  final bool isLoadingMore;

  MyParkedCarState(
      {required this.parkedCarList, this.isLoadingMore = false});

  MyParkedCarState copyWith({
    List<DriverParkedCarModel>? parkedCarList,
    bool? isLoadingMore,
  }) {
    return MyParkedCarState(
      parkedCarList: parkedCarList ?? this.parkedCarList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
