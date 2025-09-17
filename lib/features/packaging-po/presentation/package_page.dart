import 'dart:developer';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/custom_app_bar.dart';
import 'package:dazzles/features/packaging-po/data/model/supplier_model.dart';
import 'package:dazzles/features/packaging-po/data/provider/get%20suppliers/get_suppliers_controller.dart';
import 'package:dazzles/features/packaging-po/data/provider/get%20suppliers/suppliers_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

class PackagePage extends ConsumerStatefulWidget {
  const PackagePage({super.key});

  @override
  ConsumerState<PackagePage> createState() => _POPageState();
}

class _POPageState extends ConsumerState<PackagePage> {
  final _scrollController = ScrollController();
  late Debouncer _debauncer;

  @override
  void initState() {
    super.initState();
    _debauncer = Debouncer(milliseconds: 200);
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

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isTab = ResponsiveHelper.isTablet();
    final poController = ref.watch(
      getAllSuppliersControllerProvider,
    );
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        centerTitle: false,
        title: Text("Packaging"),
      ),
      body: Column(
        children: [
          AppMargin(
              child: TextFormField(
            controller: _searchController,
            onChanged: (vaue) {
              _debauncer.run(
                () {
                  ref
                      .read(getAllSuppliersControllerProvider.notifier)
                      .onSearch(vaue);
                },
              );
            },
            style: AppStyle.normalStyle(
                color: AppColors.kPrimaryColor,
                fontSize: isTab ? ResponsiveHelper.fontSmall : null),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: isTab ? 20 : 0),
              hintText: "Search Package",
              hintStyle: AppStyle.normalStyle(
                color: AppColors.kPrimaryColor,
                fontSize: isTab ? ResponsiveHelper.fontSmall : null,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              fillColor: AppColors.kFillColor.withAlpha(70),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                    left: isTab ? 20 : 8, right: isTab ? 10 : 0),
                child: Icon(
                  size: isTab ? 40 : null,
                  SolarIconsOutline.magnifier,
                  color: AppColors.kPrimaryColor,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        return ref.refresh(getAllSuppliersControllerProvider);
                      },
                      icon: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: isTab ? 20 : 8),
                        child: Icon(
                          Icons.clear,
                          size: isTab ? 40 : null,
                        ),
                      ),
                    )
                  : null,
            ),
          )),
          AppSpacer(
            hp: .01,
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                _searchController.clear();
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
                                        bottom:
                                            index == purchaseOrders.length - 1
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(SupplierModel po) {
    return InkWell(
      onTap: () {
        context.push(
          poProductsScreen,
          extra: {"id": po.id.toString(), "supplier": po.supplierName},
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.kFillColor)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                  ),
                  AppSpacer(
                    wp: .02,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          po.supplierName,
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
                  ),
                ],
              ),
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
