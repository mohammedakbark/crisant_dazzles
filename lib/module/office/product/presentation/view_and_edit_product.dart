
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/product/data/models/product_data_model.dart';
import 'package:dazzles/module/office/product/data/models/product_model.dart';
import 'package:dazzles/module/office/product/data/providers/get_product_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewAndEditProductScreen extends ConsumerStatefulWidget {
  final int productId;
  final String productName;
  ViewAndEditProductScreen(
      {super.key, required this.productId, required this.productName});

  @override
  ConsumerState<ViewAndEditProductScreen> createState() =>
      _ViewAndEditProductScreenState();
}

class _ViewAndEditProductScreenState
    extends ConsumerState<ViewAndEditProductScreen> {
  @override
  void initState() {
    Future.microtask(
      () {
        ref.invalidate(getProductDataControllerProvider(widget.productId));
      },
    );
    super.initState();
  }

  final imageVersion = DateTime.timestamp().toString();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
          leading: AppBackButton(),
          title: AppBarText(title: widget.productName,)),
      body: AppMargin(
          child: BuildStateManageComponent(
        stateController:
            ref.watch(getProductDataControllerProvider(widget.productId)),
        errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
        successWidget: (data) {
          final model = data as ProductDataModel;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacer(
                  hp: .01,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.kBorderColor.withAlpha(10),
                  ),
                  width: ResponsiveHelper.wp,
                  height: ResponsiveHelper.hp * .3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: widget.productId.toString(),
                        child: AppNetworkImage(

                            // errorIcon: Image.asset(AppImages.defaultImage),
                            fit: BoxFit.cover,
                            imageVersion: imageVersion,
                            imageFile: ApiConstants.imageBaseUrl +
                                model.productPicture),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: OutlinedButton(
                              onPressed: () {
                                context.push(openImage, extra: {
                                  "path": ApiConstants.imageBaseUrl +
                                      model.productPicture,
                                  "heroTag": widget.productId.toString(),
                                  "enableEditButton": true,
                                  "prouctModel": ProductModel(
                                      id: widget.productId,
                                      productName: model.productName,
                                      productPicture: model.productPicture,
                                      category: model.productCategory,
                                      productSize: model.productsize,
                                      color: model.color)
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(
                                    ResponsiveHelper.isTablet() ? 10 : 0),
                                child: Text(
                                  "Edit and View",
                                  style: AppStyle.mediumStyle(
                                      fontSize: ResponsiveHelper.isTablet()
                                          ? ResponsiveHelper.fontSmall
                                          : null),
                                ),
                              )))
                    ],
                  ),
                ),
                AppSpacer(
                  hp: .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.productName,
                      style: AppStyle.largeStyle(
                          fontSize: ResponsiveHelper.isTablet()
                              ? ResponsiveHelper.fontSmall
                              : null),
                    ),
                    Text(
                      "₹${model.productSellingPrice}",
                      style: AppStyle.largeStyle(
                          fontSize: ResponsiveHelper.isTablet()
                              ? ResponsiveHelper.fontSmall
                              : null),
                    ),
                  ],
                ),
                AppSpacer(
                  hp: .01,
                ),
                model.productDescription != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: ResponsiveHelper.wp,
                            decoration: BoxDecoration(
                              color: AppColors.kBorderColor.withAlpha(10),
                            ),
                            child: Text(
                              model.productDescription!,
                              style: AppStyle.smallStyle(
                                  fontSize: ResponsiveHelper.fontSmall),
                            ),
                          ),
                          AppSpacer(
                            hp: .02,
                          ),
                        ],
                      )
                    : SizedBox(),

                // PRODUCT DETAILS

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.kBorderColor.withAlpha(10),
                  ),
                  child: Column(
                    children: [
                      _buildEditFiled(title: "Supplier", value: model.supplier),
                      _buildDevider(),
                      Row(
                        children: [
                          Flexible(
                            child: _buildEditFiled(
                                title: "Quantity",
                                value: model.availableQuantity.toString()),
                          ),
                          Flexible(
                            child: _buildEditFiled(
                                title: "Size", value: model.productsize),
                          ),
                        ],
                      ),
                      _buildDevider(),
                      Row(
                        children: [
                          Flexible(
                            child: _buildEditFiled(
                                title: "Category",
                                value: model.productCategory),
                          ),
                          Flexible(
                            child: _buildEditFiled(
                                title: "Color", value: model.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSpacer(
                  hp: .02,
                ),
                // ATTRIBUTES
                model.formattedAttributes.isNotEmpty
                    ? Text(
                        "Attributes",
                        style: AppStyle.boldStyle(
                            fontSize: ResponsiveHelper.fontMedium),
                      )
                    : SizedBox(),
                AppSpacer(
                  hp: .02,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.kBorderColor.withAlpha(10),
                  ),
                  child: Column(
                      children: model.formattedAttributes
                          .map(
                            (attribute) => Column(
                              children: [
                                _buildEditFiled(
                                    title: attribute.attributename,
                                    value: attribute.attributevalue),
                                _buildDevider()
                              ],
                            ),
                          )
                          .toList()),
                ),
                AppSpacer(
                  hp: .04,
                )
              ],
            ),
          );
        },
      )),
    );
  }

  Widget _buildDevider() => Divider(
        height: 1,
        thickness: 2,
        color: AppColors.kBgColor,
      );
  Widget _buildEditFiled({required String title, required String value}) =>
      Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyle.normalStyle(
                  fontSize: ResponsiveHelper.isTablet()
                      ? ResponsiveHelper.fontExtraSmall
                      : null),
            ),
            AppSpacer(
              hp: .01,
            ),
            Container(
              width: ResponsiveHelper.wp,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kWhite.withAlpha(10),
                    )
                  ],
                  color: AppColors.kBgColor,
                  borderRadius: BorderRadius.circular(7)),
              child: Text(
                value,
                style:
                    AppStyle.smallStyle(fontSize: ResponsiveHelper.fontSmall),
              ),
              //  Text(
              //   value,
              //   style: AppStyle.boldStyle(color: AppColors.kWhite),
              // ),
            ),
          ],
        ),
      );
}
