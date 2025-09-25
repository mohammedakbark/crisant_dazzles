import 'dart:developer';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/custom_componets.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/navigation/data/model/upcoming_product_model.dart';
import 'package:dazzles/features/navigation/data/provider/upcoming%20product%20controller/upcoming_product_state.dart';
import 'package:dazzles/features/navigation/data/provider/upcoming%20product%20controller/upcoming_products_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingProductsScreen extends ConsumerStatefulWidget {
  const UpcomingProductsScreen({super.key});

  @override
  ConsumerState<UpcomingProductsScreen> createState() =>
      _UpcomingProductsScreenState();
}

class _UpcomingProductsScreenState
    extends ConsumerState<UpcomingProductsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    try {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            ref.read(upcomingProductsControllerProvider.notifier).hasMore) {
          ref.read(upcomingProductsControllerProvider.notifier).loadMore();
        }
      });
    } catch (e) {
      log("Error");
    }
    Future.microtask(() {
      ref.invalidate(upcomingProductsControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
      final isTab = ResponsiveHelper.isTablet();

      final upcomingProductController =
          ref.watch(upcomingProductsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: AppBarText(title: "Upcoming products"),
      ),
      body: BuildStateManageComponent(
        stateController: upcomingProductController,
        successWidget: (data) {
          final state = data as UpcomingProductState;
          final products = state.products;

          return products.isEmpty
              ? AppErrorView(error: "No Upcoming products found")
              : Column(
                  children: [
                    ref
                            .watch(upcomingProductsControllerProvider.notifier)
                            .isLoadingMore
                        ? AppLoading(isTextLoading: true)
                        : AppSpacer(hp: .02),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        separatorBuilder: (context, index) => AppSpacer(
                          hp: .01,
                        ),
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) =>
                            _buildTile(products[index]),
                      ),
                    ),
                  ],
                );
        },
        errorWidget: (p0, p1) => AppErrorView(
          error: p0.toString(),
          onRetry: () {
            return ref.refresh(upcomingProductsControllerProvider);
          },
        ),
      ),
    );
  }

  Widget _buildTile(UpcomingProductsModel product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kPrimaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.cube_box,
                    ),
                    AppSpacer(
                      wp: .03,
                    ),
                    Flexible(
                      child: Text(
                        product.supplierName,
                        style: AppStyle.boldStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                AppSpacer(
                  hp: .01,
                ),
                _buidText("Inv. No. : ", product.invoiceNumber),
                _buidText(
                    "Inv. Date : ", IntlC.convertToDate(product.invoiceDate)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buidText(String title, String data, {Color? color}) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 5),
      child: RichText(
          text: TextSpan(
              style: AppStyle.mediumStyle(
                  fontSize: ResponsiveHelper.isTablet()
                      ? ResponsiveHelper.fontExtraSmall
                      : null),
              text: title,
              children: [
            TextSpan(
              text: data,
              style: AppStyle.boldStyle(
                  color: color,
                  fontSize: ResponsiveHelper.isTablet()
                      ? ResponsiveHelper.fontExtraSmall
                      : null),
            )
          ])),
    );
  }
}
