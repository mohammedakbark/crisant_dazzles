import 'dart:developer';

import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/product/data/models/product_data_model.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/product/providers/get_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          ref.read(allProductControllerProvider.notifier).hasMore) {
        ref.read(allProductControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productController = ref.watch(allProductControllerProvider);
    return AppMargin(
      child: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(allProductControllerProvider);
        },
        child: BuildStateManageComponent(
          controller: productController,
          errorWidget:
              (p0, p1) => AppErrorView(
                error: p0.toString(),
                onRetry: () {
                  return ref.refresh(allProductControllerProvider);
                },
              ),
          successWidget: (data) {
            final products = data as List<ProductModel>;

            return products.isEmpty
                ? AppErrorView(error: "Products not found")
                : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder:
                            (context, index) => _buildTile(products[index]),
                      ),
                    ),
                    ref
                            .watch(allProductControllerProvider.notifier)
                            .isLoadingMore
                        ? AppLoading(isTextLoading: true)
                        : SizedBox(),
                  ],
                );
          },
        ),
      ),
    );
  }

  Widget _buildTile(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kPrimaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: AppNetworkImage(
                imageFile:
                    "${ApiConstants.imageBaseUrl}${product.productPicture ?? ''}",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName, style: AppStyle.boldStyle()),
                Container(
                  padding: EdgeInsets.all(4),
                  color: AppColors.kPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category,
                        style: AppStyle.mediumStyle(
                          color: AppColors.kSecondaryColor,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        color: AppColors.kBgColor,
                        child: Text(
                          product.productSize,
                          style: AppStyle.mediumStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
