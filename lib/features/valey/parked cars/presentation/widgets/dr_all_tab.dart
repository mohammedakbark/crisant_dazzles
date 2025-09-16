import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/features/valey/parked%20cars/data/model/driver_store_model.dart';
import 'package:dazzles/features/valey/parked%20cars/data/provider/parked%20car%20controller/all_parked_car_state.dart';
import 'package:dazzles/features/valey/parked%20cars/data/provider/parked%20car%20controller/driver_parked_car_controller.dart';
import 'package:dazzles/features/valey/parked%20cars/presentation/widgets/driver_car_card.dart';
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
      errorWidget: (p0, p1) => AppErrorView(
          icon: Icon(
            size: 30,
            Icons.car_crash_outlined,
            color: AppColors.kTextPrimaryColor,
          ),
          error: p0.toString()),
      successWidget: (state) {
        final data = state as AllParkedCarState;
        return Column(
          children: [
            _shopDropDown(data),
            Expanded(
              child: data.parkedCarList.isEmpty
                  ? AppErrorView(
                      icon: Icon(
                        size: 30,
                        Icons.car_crash_outlined,
                        color: AppColors.kTextPrimaryColor,
                      ),
                      error: "No Cars Parked today.")
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _allListScrollController,
                      itemBuilder: (context, index) {
                        return DriverValetParkingCard(
                            valetData: data.parkedCarList[index]);
                      },
                      itemCount: data.parkedCarList.length),
            ),
          ],
        );
      },
    );
  }

  Widget _shopDropDown(AllParkedCarState data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton(
          icon: Row(
            children: [
              Text(data.selectedStore == null
                  ? "All Store"
                  : data.selectedStore!.storeName),
              AppSpacer(
                wp: .01,
              ),
              Icon(
                Icons.arrow_drop_down_circle_outlined,
                size: 18,
              ),
            ],
          ),
          itemBuilder: (context) => [
            ...[
              PopupMenuItem(
                value: DriverStoreModel(
                    storeId: 0, storeName: "All Store", storeShortName: ''),
                child: Text("All Store"),
              )
            ],
            ...data.storeList
                .map(
                  (store) => PopupMenuItem(
                    value: store,
                    child: Text(store.storeName),
                  ),
                )
                .toList()
          ],
          onSelected: (value) {
            ref
                .watch(drGetParkedCarListControllerProvider.notifier)
                .onSelectStore(value);
          },
        ),
      ],
    );
  }
}
