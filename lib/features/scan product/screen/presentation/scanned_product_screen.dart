import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/features/scan%20product/data/model/scanned_product_model.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ScannedProductScreen extends StatelessWidget {
  final ScannedProductModel productDataModel;
  ScannedProductScreen({super.key, required this.productDataModel});
  final imageVersion = DateTime.timestamp().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: AppBackButton(),
          title: AppBarText(
            onTap: () async {
              await Clipboard.setData(
                  ClipboardData(text: productDataModel.productName));
              showToastMessage(context,
                  "${productDataModel.productName} added to clipboard");
            },
            title: productDataModel.productName,
          )),
      body: AppMargin(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacer(
              hp: .01,
            ),
            InkWell(
              onTap: () {
                context.push(openImage, extra: {
                  "path": ApiConstants.mediaBaseUrl +
                      productDataModel.productPicture,
                  "heroTag": productDataModel.id.toString(),
                  "enableEditButton": false,
                  "prouctModel": ProductModel(
                      id: productDataModel.id,
                      productName: productDataModel.productName,
                      productPicture: productDataModel.productPicture,
                      category: productDataModel.category,
                      productSize: productDataModel.productSize,
                      color: productDataModel.color)
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kBorderColor.withAlpha(10),
                ),
                width: ResponsiveHelper.wp,
                height: ResponsiveHelper.hp * .3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: productDataModel.id.toString(),
                      child: AppNetworkImage(

                          // errorIcon: Image.asset(AppImages.defaultImage),
                          fit: BoxFit.cover,
                          imageVersion: imageVersion,
                          imageFile: ApiConstants.mediaBaseUrl +
                              productDataModel.productPicture),
                    ),
                    // Positioned(
                    //     right: 10,
                    //     bottom: 10,
                    //     child: OutlinedButton(
                    //         onPressed: () {
                    //           context.push(openImage, extra: {
                    //             "path": ApiConstants.imageBaseUrl +
                    //                 productDataModel.productPicture,
                    //             "heroTag": productDataModel.id.toString(),
                    //             "enableEditButton": false,
                    //             "prouctModel": ProductModel(
                    //                 id: productDataModel.id,
                    //                 productName: productDataModel.productName,
                    //                 productPicture:
                    //                     productDataModel.productPicture,
                    //                 category: productDataModel.category,
                    //                 productSize: productDataModel.productSize,
                    //                 color: productDataModel.color)
                    //           });
                    //         },
                    //         child: Padding(
                    //           padding: EdgeInsets.all(
                    //               ResponsiveHelper.isTablet() ? 10 : 0),
                    //           child: Text(
                    //             "Edit and View",
                    //             style: AppStyle.mediumStyle(
                    //                 fontSize: ResponsiveHelper.isTablet()
                    //                     ? ResponsiveHelper.fontSmall
                    //                     : null),
                    //           ),
                    //         )))
                  ],
                ),
              ),
            ),
            AppSpacer(
              hp: .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productDataModel.productName,
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

            // PRODUCT DETAILS

            Container(
              decoration: BoxDecoration(
                color: AppColors.kBorderColor.withAlpha(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (productDataModel.salesprice.isNotEmpty)
                        Flexible(
                            child: _buildEditFiled(
                                title: "Sales Price",
                                value: "₹${productDataModel.salesprice}")),
                      if (productDataModel.purchaseprice.isNotEmpty)
                        Flexible(
                          child: _buildEditFiled(
                              title: "Purchase Price",
                              value: "₹${productDataModel.purchaseprice}"),
                        ),
                    ],
                  ),
                  _buildDevider(),
                  if (productDataModel.supplier.isNotEmpty)
                    _buildEditFiled(
                        title: "Supplier", value: productDataModel.supplier),
                  _buildDevider(),
                  _buildEditFiled(
                      title: "Size", value: productDataModel.productSize),
                  _buildDevider(),
                  Row(
                    children: [
                      Flexible(
                        child: _buildEditFiled(
                            title: "Category",
                            value: productDataModel.category),
                      ),
                      Flexible(
                        child: _buildEditFiled(
                            title: "Color", value: productDataModel.color),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacer(
              hp: .02,
            ), // QUANITY

            productDataModel.quantity.isNotEmpty
                ? Text(
                    "Quantity",
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
                  children: productDataModel.quantity
                      .map(
                        (store) => Column(
                          children: [
                            _buildEditFiled(
                                title: store.storeName,
                                value: store.quantity.toString()),
                            _buildDevider()
                          ],
                        ),
                      )
                      .toList()),
            ),
            AppSpacer(
              hp: .02,
            ),
            // ATTRIBUTES
            productDataModel.attributes.isNotEmpty
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
                  children: productDataModel.attributes
                      .map(
                        (attribute) => Column(
                          children: [
                            _buildEditFiled(
                                title: attribute.name, value: attribute.value),
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
