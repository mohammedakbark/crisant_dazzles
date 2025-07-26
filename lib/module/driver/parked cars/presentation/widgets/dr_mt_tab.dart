import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/driver_my_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/my_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/presentation/widgets/driver_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrMtTab extends ConsumerStatefulWidget {
  const DrMtTab({super.key});

  @override
  ConsumerState<DrMtTab> createState() => _DrMtTabState();
}

class _DrMtTabState extends ConsumerState<DrMtTab> {
  final _myListScrollController = ScrollController();

  @override
  void initState() {
    Future.microtask(
      () {
        ref.invalidate(drGetMyParkedCarListControllerProvider);
      },
    );
    try {
      _myListScrollController.addListener(() {
        if (_myListScrollController.position.pixels >=
                _myListScrollController.position.maxScrollExtent - 200 &&
            ref.read(drGetMyParkedCarListControllerProvider.notifier).hasMore) {
          ref.read(drGetMyParkedCarListControllerProvider.notifier).loadMore();
        }
      });
    } catch (e) {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BuildStateManageComponent(
      stateController: ref.watch(drGetMyParkedCarListControllerProvider),
      errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
      successWidget: (state) {
        final data = state as MyParkedCarState;
        return data.parkedCarList.isEmpty
            ? AppErrorView(
                icon: Icon(
                  Icons.car_crash_outlined,
                  color: AppColors.kTextPrimaryColor,
                ),
                error: "Cars not found!")
            : ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _myListScrollController,
                itemBuilder: (context, index) {
                  return DriverValetParkingCard(
                      valetData: data.parkedCarList[index]);
                },
                itemCount: data.parkedCarList.length);
      },
    );
  }
}
