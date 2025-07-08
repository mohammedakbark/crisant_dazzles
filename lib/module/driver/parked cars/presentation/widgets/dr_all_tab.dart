import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/driver_my_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/my_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/all_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/driver_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/presentation/widgets/driver_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrAllTab extends ConsumerStatefulWidget {
  const DrAllTab({super.key});

  @override
  ConsumerState<DrAllTab> createState() => _DrAllTabState();
}

class _DrAllTabState extends ConsumerState<DrAllTab> {
  final _allListScrollController = ScrollController();

  @override
  void initState() {
    Future.microtask(
      () {
        ref.invalidate(drGetParkedCarListControllerProvider);
      },
    );
    try {
      _allListScrollController.addListener(() {
        if (_allListScrollController.position.pixels >=
                _allListScrollController.position.maxScrollExtent - 200 &&
            ref.read(drGetParkedCarListControllerProvider.notifier).hasMore) {
          ref.read(drGetParkedCarListControllerProvider.notifier).loadMore();
        }
      });
    } catch (e) {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BuildStateManageComponent(
      stateController: ref.watch(drGetParkedCarListControllerProvider),
      errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
      successWidget: (state) {
        final data = state as AllParkedCarState;
        return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _allListScrollController,
            itemBuilder: (context, index) {
              return DriverValetParkingCard(
                  valetData: data.parkedCarList[index]);
            },
            itemCount: data.parkedCarList.length);
      },
    );
  }
}
