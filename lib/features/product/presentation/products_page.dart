import 'dart:developer';

import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/componets.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/product/data/providers/product_controller/get_products_controller.dart';
import 'package:dazzles/features/product/data/providers/product_controller/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

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

    try {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            ref.read(allProductControllerProvider.notifier).hasMore) {
          ref.read(allProductControllerProvider.notifier).loadMore();
        }
      });
    } catch (e) {
      log("Error");
    }
    // Future.microtask(() {
    //   ref.invalidate(allProductControllerProvider);
    // });
  }

  final _debouncer = Debouncer(milliseconds: 500);
  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  String imageVersion = DateTime.now().microsecondsSinceEpoch.toString();
  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(allProductControllerProvider);
    final productsController = ref.read(allProductControllerProvider.notifier);

    return 
    AppMargin(
      child: Column(
        children: [
          AppSpacer(hp: .01),
          TextField(
            controller: productsController.searchContoller,
            onChanged: (value) {
              _debouncer.run(() {
                ref
                    .watch(allProductControllerProvider.notifier)
                    .onSearchProduct(value);
              });
            },
            style: AppStyle.normalStyle(color: AppColors.kPrimaryColor),
            decoration: InputDecoration(
              suffixIcon: productsController.searchContoller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        return ref.refresh(allProductControllerProvider);
                      },
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              hintText: "Product Search",
              hintStyle: AppStyle.normalStyle(color: AppColors.kPrimaryColor),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: AppColors.kBgColor),
                borderRadius: BorderRadius.circular(50),
              ),
              fillColor:    AppColors.kFillColor.withAlpha(70),
              filled: true,
              border: OutlineInputBorder(
                                 borderSide: BorderSide(color: AppColors.kBgColor),

                borderRadius: BorderRadius.circular(50),
              ),
              prefixIcon: Icon(
                SolarIconsOutline.magnifier,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                imageVersion = DateTime.now().microsecondsSinceEpoch.toString();
                return ref.refresh(allProductControllerProvider);
              },
              child: BuildStateManageComponent(
                stateController: productsState,
                errorWidget: (p0, p1) => AppErrorView(
                  error: p0.toString(),
                  onRetry: () {
                    return ref.refresh(allProductControllerProvider);
                  },
                ),
                successWidget: (data) {
                  final state = data as ProductSuccessState;
                  final products = state.products;

                  return products.isEmpty
                      ? AppErrorView(error: "Products not found")
                      : Column(
                          children: [
                            AppSpacer(hp: .02),
                            Expanded(
                              child: GridView.builder(
                                controller: _scrollController,
                                physics: BouncingScrollPhysics(),
                                itemCount: products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) =>
                                    _buildTile(products[index]),
                              ),
                            ),
                            ref
                                    .watch(
                                        allProductControllerProvider.notifier)
                                    .isLoadingMore
                                ? AppLoading(isTextLoading: true)
                                : SizedBox(),
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

  Widget _buildTile(ProductModel product) {
    return InkWell(
      onTap: () {
        context.push(
          openImage,
          extra: {
            "heroTag": product.id.toString(),
            "path":
                "${ApiConstants.imageBaseUrl}${product.productPicture ?? ''}",
            "enableEditButton": true,
            "prouctModel": product,
          },
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              
              // borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kPrimaryColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Hero(
                        tag: product.id.toString(),
                        child: AppNetworkImage(
                          imageVersion: imageVersion,
                          imageFile:
                              "${ApiConstants.imageBaseUrl}${product.productPicture}",
                        )),
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
          ),
          Positioned(
            left: 10,
            top: 10,
            child: buildIdBadge(
              context,
              product.id.toString(),
              enableCopy: true,
            ),
          ),
        ],
      ),
    );
  }
}
