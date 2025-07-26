import 'dart:developer';

import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/driver_my_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/my_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/driver_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/all_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/presentation/widgets/dr_all_tab.dart';
import 'package:dazzles/module/driver/parked%20cars/presentation/widgets/dr_mt_tab.dart';
import 'package:dazzles/module/driver/parked%20cars/presentation/widgets/driver_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverParkedCarsScreen extends ConsumerStatefulWidget {
  const DriverParkedCarsScreen({super.key});

  @override
  ConsumerState<DriverParkedCarsScreen> createState() =>
      _DriverParkedCarsScreenState();
}

class _DriverParkedCarsScreenState extends ConsumerState<DriverParkedCarsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            Column(
              children: [
                TabBar(
                    labelStyle: AppStyle.boldStyle(),
                    unselectedLabelStyle: AppStyle.normalStyle(),
                    indicatorColor: AppColors.kWhite,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: _tabController,
                    dividerHeight: .5,
                    tabs: [
                      Tab(
                        text: "My Parkings",
                      ),
                      Tab(
                        text: "All Parkings",
                      )
                    ]),
                Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        children: [DrMtTab(), DrAllTab()]))
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  ref
                          .watch(drGetParkedCarListControllerProvider.notifier)
                          .isLoadingMore
                      ? Container(
                          color: AppColors.kBgColor,
                          child: AppLoading(
                            isTextLoading: true,
                          ),
                        )
                      : SizedBox.shrink(),
                  ref
                          .watch(
                              drGetMyParkedCarListControllerProvider.notifier)
                          .isLoadingMore
                      ? Container(
                          color: AppColors.kBgColor,
                          child: AppLoading(
                            isTextLoading: true,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            ref.watch(isUploadingInitialVideoProvider)
                ? Container(
                    alignment: Alignment.center,
                    color: AppColors.kBgColor.withAlpha(100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppLoading(),
                        AppSpacer(
                          hp: .03,
                        ),
                        Text(
                          "Uploading please wait..",
                          style: AppStyle.boldStyle(),
                        )
                      ],
                    ))
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  // Widget myListTab() {
  //   return BuildStateManageComponent(
  //     stateController: ref.watch(drGetMyParkedCarListControllerProvider),
  //     errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
  //     successWidget: (state) {
  //       final data = state as MyParkedCarState;
  //       return ListView.builder(
  //           physics: AlwaysScrollableScrollPhysics(),
  //           controller: _myListScrollController,
  //           itemBuilder: (context, index) {
  //             return DriverValetParkingCard(
  //                 valetData: data.parkedCarList[index]);
  //           },
  //           itemCount: data.parkedCarList.length);
  //     },
  //   );
  // }

  // Widget allListTab() {
  //   return BuildStateManageComponent(
  //     stateController: ref.watch(drGetParkedCarListControllerProvider),
  //     errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
  //     successWidget: (state) {
  //       final data = state as AllParkedCarState;
  //       return ListView.builder(
  //           physics: AlwaysScrollableScrollPhysics(),
  //           controller: _allListScrollController,
  //           itemBuilder: (context, index) {
  //             return DriverValetParkingCard(
  //                 valetData: data.parkedCarList[index]);
  //           },
  //           itemCount: data.parkedCarList.length);
  //     },
  //   );
  // }
}
