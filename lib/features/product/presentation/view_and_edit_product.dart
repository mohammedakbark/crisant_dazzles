import 'package:dazzles/core/app%20permission/app_permission_extension.dart';
import 'package:dazzles/core/app%20permission/app_permissions.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/app_textfield.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/permission_hendle.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/core/utils/validators.dart';
import 'package:dazzles/features/product/data/models/product_data_model.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/product/data/providers/get_product_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

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
          title: AppBarText(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: widget.productName));
              showToastMessage(
                  context, "${widget.productName} added to clipboard");
            },
            title: widget.productName,
          )),
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
                            imageFile: ApiConstants.mediaBaseUrl +
                                model.productPicture),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: OutlinedButton(
                              onPressed: () {
                                context.push(openImage, extra: {
                                  "path": ApiConstants.mediaBaseUrl +
                                      model.productPicture,
                                  "heroTag": widget.productId.toString(),
                                  "enableEditButton": AppPermissionConfig()
                                      .has(AppPermission.updateproduct),
                                  "prouctModel": ProductModel(
                                      availableQuantity:
                                          model.productavailableQuantity,
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
                AppSpacer(
                  hp: .02,
                ),
                Text(
                  model.productName,
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
                          .has(AppPermission.purchasePriceVisibility))
                        Flexible(
                          child: _buildEditFiled(
                              title: "Purchase rate",
                              value: "₹ ${model.productPurchaseRate}"),
                        ),
                      if (AppPermissionConfig()
                          .has(AppPermission.salesPriceVisibility))
                        Flexible(
                          child: _buildEditFiled(
                              onPressed: AppPermissionConfig()
                                      .has(AppPermission.editprice)
                                  ? () {
                                      _showPriceEditDiologue(
                                          model.productSellingPrice);
                                    }
                                  : null,
                              title: "Sale Price",
                              value: "₹ ${model.productSellingPrice}"),
                        ),
                    ],
                  ),
                ),
                _buildDevider(),
                // AppSpacer(
                //   hp: .005,
                // ),

                // DESCRIPTION VIEW
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
                          _buildDevider()
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
                // AVAILABLE Quantity

                _buildQuantityView(model),
                // ATTRIBUTES

                _buildAttributesView(model),

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
  Widget _buildEditFiled(
          {required String title,
          required String value,
          void Function()? onPressed}) =>
      Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppStyle.normalStyle(
                      fontSize: ResponsiveHelper.isTablet()
                          ? ResponsiveHelper.fontExtraSmall
                          : null),
                ),
                if (onPressed != null)
                  InkWell(
                    onTap: onPressed,
                    child: Icon(
                      Icons.edit,
                      size: 15,
                    ),
                  )
              ],
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

  Widget _buildQuantityView(ProductDataModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((model.productavailableQuantity.isNotEmpty) &&
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
                  children: model.productavailableQuantity.map((store) {
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

  Widget _buildAttributesView(ProductDataModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacer(
          hp: .02,
        ),
        model.formattedAttributes.isNotEmpty
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
      ],
    );
  }

  TextEditingController _priceEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _showPriceEditDiologue(String currentPrice) {
    _priceEditingController.text = currentPrice;
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Padding(
          padding: EdgeInsetsGeometry.only(bottom: 10),
          child: Row(
            children: [
              Text("Update Price"),
            ],
          ),
        ),
        content: Material(
          child: Form(
            key: _formKey,
            child: CustomTextField(
              validator: AppValidator.requiredValidator,
              controller: _priceEditingController,
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final isSuccess = await ref
                      .read(getProductDataControllerProvider(widget.productId)
                          .notifier)
                      .onUpdateProduct(widget.productId.toString(),
                          _priceEditingController.text.trim(), context);
                }
              },
              child: Text(
                "Update",
                style: AppStyle.boldStyle(),
              ))
        ],
      ),
    );
  }
}
