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
import 'package:dazzles/module/office/purchase%20orders/data/model/po_model.dart';
import 'package:dazzles/module/office/purchase%20orders/data/provider/get%20purchase%20orders/get_purchase_orders_controller.dart';
import 'package:dazzles/module/office/purchase%20orders/data/provider/get%20purchase%20orders/po_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class POPage extends ConsumerStatefulWidget {
  const POPage({super.key});

  @override
  ConsumerState<POPage> createState() => _POPageState();
}

class _POPageState extends ConsumerState<POPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    try {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            ref.read(getAllProductOrdersControllerProvider.notifier).hasMore) {
          ref.read(getAllProductOrdersControllerProvider.notifier).loadMore();
        }
      });
      Future.microtask(
        () {
          ref.invalidate(getAllProductOrdersControllerProvider);
        },
      );
    } catch (e) {
      log("PO screen initialization Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final poController = ref.watch(
      getAllProductOrdersControllerProvider,
    );
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        return ref.refresh(getAllProductOrdersControllerProvider);
      },
      child: BuildStateManageComponent(
        stateController: poController,
        errorWidget: (p0, p1) => AppErrorView(
          error: p0.toString(),
          onRetry: () {
            return ref.refresh(getAllProductOrdersControllerProvider);
          },
        ),
        successWidget: (data) {
          final state = data as POSuccessState;
          final purchaseOrders = state.purchaseOrderList;
          return Column(
            children: [
              ref
                      .read(getAllProductOrdersControllerProvider.notifier)
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

  Widget _buildProductCard(PoModel po) {
    return InkWell(
      onTap: () {
        context.push(
          poProductsScreen,
          extra: {"id": po.id.toString(), "supplier": po.supplier},
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.kFillColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.person),
                AppSpacer(
                  wp: .02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      po.supplier,
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
                )
              ],
            ),

            const SizedBox(height: 10),

            // Invoice Date
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              color: AppColors.kGrey.withAlpha(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month,
                          color: AppColors.kTextPrimaryColor),
                      AppSpacer(
                        wp: .015,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ordered Date",
                            style: AppStyle.mediumStyle(
                                color: AppColors.kTextPrimaryColor),
                          ),
                          Text(
                            IntlC.monthDayYear(po.invoiceDate),
                            style: AppStyle.smallStyle(
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Received Date (optional)
                  if (po.receivedDate != null) ...[
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            color: AppColors.kTextPrimaryColor),
                        AppSpacer(
                          wp: .015,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Received Date",
                              style: AppStyle.mediumStyle(
                                  color: AppColors.kTextPrimaryColor),
                            ),
                            Text(
                              IntlC.monthDayYear(
                                po.receivedDate!,
                              ),
                              style: AppStyle.smallStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
