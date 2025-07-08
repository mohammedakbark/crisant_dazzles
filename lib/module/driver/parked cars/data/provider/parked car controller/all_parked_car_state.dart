import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';
import 'package:dazzles/module/driver/parked%20cars/data/model/driver_store_model.dart';

class AllParkedCarState {
  final List<DriverParkedCarModel> parkedCarList;
  final bool isLoadingMore;
  final List<DriverStoreModel> storeList;

  AllParkedCarState(
      {required this.parkedCarList,
      this.isLoadingMore = false,
      required this.storeList});

  AllParkedCarState copyWith(
      {List<DriverParkedCarModel>? parkedCarList,
      bool? isLoadingMore,
      List<DriverStoreModel>? storeList}) {
    return AllParkedCarState(
      storeList: storeList ?? this.storeList,
      parkedCarList: parkedCarList ?? this.parkedCarList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
