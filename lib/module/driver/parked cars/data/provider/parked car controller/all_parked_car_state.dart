import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';
import 'package:dazzles/module/driver/parked%20cars/data/model/driver_store_model.dart';

class AllParkedCarState {
  final List<DriverParkedCarModel> parkedCarList;
  final bool isLoadingMore;
  final List<DriverStoreModel> storeList;
  final DriverStoreModel? selectedStore;

  AllParkedCarState(
      {required this.parkedCarList,
      this.isLoadingMore = false,
      required this.storeList,
      this.selectedStore});

  AllParkedCarState copyWith(
      {List<DriverParkedCarModel>? parkedCarList,
      bool? isLoadingMore,
      List<DriverStoreModel>? storeList,
      DriverStoreModel? selectedStore}) {
    return AllParkedCarState(
        storeList: storeList ?? this.storeList,
        parkedCarList: parkedCarList ?? this.parkedCarList,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        selectedStore: selectedStore ?? this.selectedStore);
  }
}
