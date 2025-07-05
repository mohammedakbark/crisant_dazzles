import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';

class AllParkedCarState {
  final List<DriverParkedCarModel> parkedCarList;
  final bool isLoadingMore;

  AllParkedCarState(
      {required this.parkedCarList, this.isLoadingMore = false});

  AllParkedCarState copyWith({
    List<DriverParkedCarModel>? parkedCarList,
    bool? isLoadingMore,
  }) {
    return AllParkedCarState(
      parkedCarList: parkedCarList ?? this.parkedCarList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
