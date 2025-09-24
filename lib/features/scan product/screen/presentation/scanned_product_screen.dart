import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
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
import 'package:solar_icons/solar_icons.dart';

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
                  "enableEditButton":
                      AppPermissionConfig().has(AppPermission.updateproduct),
                  "prouctModel": ProductModel(
                      availableQuantity: productDataModel.quantity,
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
                    Positioned(
                        right: 10,
                        bottom: 10,
                        child: OutlinedButton(
                            onPressed: null,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  ResponsiveHelper.isTablet() ? 10 : 0),
                              child: Text(
                                AppPermissionConfig()
                                        .has(AppPermission.updateproduct)
                                    ? "Edit and View"
                                    : "View",
                                style: AppStyle.mediumStyle(
                                    fontSize: ResponsiveHelper.isTablet()
                                        ? ResponsiveHelper.fontSmall
                                        : null),
                              ),
                            )))
                  ],
                ),
              ),
            ),
            AppSpacer(
              hp: .02,
            ),
            Text(
              productDataModel.productName,
              style: AppStyle.largeStyle(
                  fontSize: ResponsiveHelper.isTablet()
                      ? ResponsiveHelper.fontSmall
                      : null),
            ),

            AppSpacer(
              hp: .01,
            ),
            // PRICE VIEW
            Container(
              decoration: BoxDecoration(
                color: AppColors.kBorderColor.withAlpha(10),
              ),
              child: Row(
                children: [
                  if (AppPermissionConfig()
                          .has(AppPermission.purchasePriceVisibility) &&
                      productDataModel.purchaseprice.isNotEmpty)
                    Flexible(
                      child: _buildEditFiled(
                          title: "Purchase rate",
                          value: "₹ ${productDataModel.purchaseprice}"),
                    ),
                  if (AppPermissionConfig()
                          .has(AppPermission.salesPriceVisibility) &&
                      productDataModel.salesprice.isNotEmpty)
                    Flexible(
                      child: _buildEditFiled(
                          title: "Sale Price",
                          value: "₹ ${productDataModel.salesprice}"),
                    ),
                ],
              ),
            ),

            // PRODUCT DETAILS

            Container(
              decoration: BoxDecoration(
                color: AppColors.kBorderColor.withAlpha(10),
              ),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     // if (productDataModel.salesprice.isNotEmpty)
                  //     Flexible(
                  //         child: _buildEditFiled(
                  //             title: "Sales Price",
                  //             value: """₹${productDataModel.salesprice}""")),
                  //     // if (productDataModel.purchaseprice.isNotEmpty)
                  //     Flexible(
                  //       child: _buildEditFiled(
                  //           title: "Purchase Price",
                  //           value: """₹${productDataModel.purchaseprice}"""),
                  //     ),
                  //   ],
                  // ),
                  // _buildDevider(),
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
            // Store Availability

            _buildQuantityView(productDataModel),
            // Attributtes
            _buildAttributesView(productDataModel),
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

  Widget _buildQuantityView(ScannedProductModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((model.quantity.isNotEmpty) &&
            (AppPermissionConfig().has(AppPermission.stockquantityvisibility) ||
                AppPermissionConfig()
                    .has(AppPermission.soldquantityvisibility))) ...[
          AppSpacer(
            hp: .02,
          ),
          Text(
            "Store Availability",
            style: AppStyle.boldStyle(fontSize: ResponsiveHelper.fontMedium),
          ),
          AppSpacer(
            hp: .02,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.kBorderColor.withAlpha(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header row
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // Store name column
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Store",
                          style: AppStyle.boldStyle(
                              fontSize: ResponsiveHelper.fontSmall),
                        ),
                      ),
                      // Stock header (centered)
                      if (AppPermissionConfig()
                          .has(AppPermission.stockquantityvisibility))
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Stock",
                              style: AppStyle.boldStyle(
                                  fontSize: ResponsiveHelper.fontSmall),
                            ),
                          ),
                        ),
                      // Sales header (centered)
                      if (AppPermissionConfig()
                          .has(AppPermission.soldquantityvisibility))
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sales",
                              style: AppStyle.boldStyle(
                                  fontSize: ResponsiveHelper.fontSmall),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // List of stores
                Column(
                  children: model.quantity.map((store) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              // Store name
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Icon(SolarIconsBold.shop, size: 15),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        store.storeShortName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: AppStyle.boldStyle(
                                          fontSize: ResponsiveHelper.isTablet()
                                              ? ResponsiveHelper.fontExtraSmall
                                              : ResponsiveHelper.fontSmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Stock value (centered)

                              if (AppPermissionConfig()
                                  .has(AppPermission.stockquantityvisibility))
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.kBgColor,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                AppColors.kWhite.withAlpha(10)),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        store.quantity?.toString() ?? '0',
                                        style: AppStyle.smallStyle(
                                            fontSize:
                                                ResponsiveHelper.fontSmall),
                                      ),
                                    ),
                                  ),
                                ),

                              SizedBox(width: 8),

                              // Sales value (centered)
                              if (AppPermissionConfig()
                                  .has(AppPermission.soldquantityvisibility))
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.kBgColor,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                AppColors.kWhite.withAlpha(10)),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        store.sales?.toString() ?? '0',
                                        style: AppStyle.smallStyle(
                                            fontSize:
                                                ResponsiveHelper.fontSmall),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Divider between rows

                        _buildDevider(),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAttributesView(ScannedProductModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacer(
          hp: .02,
        ),
        model.attributes.isNotEmpty
            ? Text(
                "Attributes",
                style:
                    AppStyle.boldStyle(fontSize: ResponsiveHelper.fontMedium),
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
              children: model.attributes
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
      ],
    );
  }
}
