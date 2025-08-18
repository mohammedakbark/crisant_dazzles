import 'dart:developer';

import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/packaging/data/model/supplier_model.dart';
import 'package:dazzles/module/office/packaging/data/provider/get%20suppliers/get_suppliers_controller.dart';
import 'package:dazzles/module/office/packaging/data/provider/get%20suppliers/suppliers_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PackagePage extends ConsumerStatefulWidget {
  const PackagePage({super.key});

  @override
  ConsumerState<PackagePage> createState() => _POPageState();
}

class _POPageState extends ConsumerState<PackagePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    try {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            ref.read(getAllSuppliersControllerProvider.notifier).hasMore) {
          ref.read(getAllSuppliersControllerProvider.notifier).loadMore();
        }
      });
      Future.microtask(
        () {
          ref.invalidate(getAllSuppliersControllerProvider);
        },
      );
    } catch (e) {
      log("PO screen initialization Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final poController = ref.watch(
      getAllSuppliersControllerProvider,
    );
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        return ref.refresh(getAllSuppliersControllerProvider);
      },
      child: BuildStateManageComponent(
        stateController: poController,
        errorWidget: (p0, p1) => AppErrorView(
          error: p0.toString(),
          onRetry: () {
            return ref.refresh(getAllSuppliersControllerProvider);
          },
        ),
        successWidget: (data) {
          final state = data as SuppliersSuccessState;
          final purchaseOrders = state.purchaseOrderList;
          return Column(
            children: [
              ref
                      .read(getAllSuppliersControllerProvider.notifier)
                      .isLoadingMore
                  ? AppLoading(isTextLoading: true)
                  : SizedBox(),
              Expanded(
                child: purchaseOrders.isEmpty
                    ? AppErrorView(
                        error: "No New Purchase Orders",
                        errorExp: 'No more  purchase orders found!',
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => AppSpacer(
                          hp: .01,
                        ),
                        controller: _scrollController,
                        itemCount: purchaseOrders.length,
                        itemBuilder: (context, index) {
                          final po = purchaseOrders[index];
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: index == purchaseOrders.length - 1
                                    ? ResponsiveHelper.hp * .05
                                    : 0),
                            child: _buildProductCard(po),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(SupplierModel po) {
    return InkWell(
      onTap: () {
        context.push(
          poProductsScreen,
          extra: {"id": po.id.toString(), "supplier": po.supplierId},
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.kFillColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                ),
                AppSpacer(
                  wp: .02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      po.supplierId,
                      style: AppStyle.boldStyle(
                        fontSize: 14,
                        color: Colors.white, // Bright for visibility
                      ),
                    ),
                    Text(
                      "Inv. No. ${po.invoiceNumber}",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AppSpacer(
              wp: .02,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.kGrey,
            ),
          ],
        ),
      ),
    );
  }
}
