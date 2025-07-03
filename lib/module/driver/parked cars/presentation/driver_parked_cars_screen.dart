import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/driver_my_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/my_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/driver_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/all_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/presentation/widgets/driver_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverParkedCarsScreen extends ConsumerStatefulWidget {
  const DriverParkedCarsScreen({super.key});

  @override
  ConsumerState<DriverParkedCarsScreen> createState() =>
      _DriverParkedCarsScreenState();
}

class _DriverParkedCarsScreenState
    extends ConsumerState<DriverParkedCarsScreen> {
  @override
  void initState() {
    Future.microtask(
      () {
        ref.invalidate(drGetParkedCarListControllerProvider);
        ref.invalidate(drGetMyParkedCarListControllerProvider);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              dividerHeight: .5,
              tabs: [
              Tab(
                text: "My Parkings",
              ),
              Tab(
                text: "All Parkings",
              )
            ]),
            Expanded(child: TabBarView(children: [myListTab(), allListTab()]))
          ],
        ),
      ),
    );
  }

  Widget myListTab() {
    return BuildStateManageComponent(
      stateController: ref.watch(drGetMyParkedCarListControllerProvider),
      errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
      successWidget: (state) {
        final data = state as MyParkedCarState;
        return ListView.builder(
            itemBuilder: (context, index) {
              return DriverValetParkingCard(
                  valetData: data.parkedCarList[index]);
            },
            itemCount: data.parkedCarList.length);
      },
    );
  }

  Widget allListTab() {
    return BuildStateManageComponent(
      stateController: ref.watch(drGetParkedCarListControllerProvider),
      errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
      successWidget: (state) {
        final data = state as AllParkedCarState;
        return ListView.builder(
            itemBuilder: (context, index) {
              return DriverValetParkingCard(
                  valetData: data.parkedCarList[index]);
            },
            itemCount: data.parkedCarList.length);
      },
    );
  }
}
