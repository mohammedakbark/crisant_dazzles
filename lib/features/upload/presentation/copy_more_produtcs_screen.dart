import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/features/upload/providers/select%20product%20controller/product_id_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';

class CopyMoreProdutcsScreen extends ConsumerStatefulWidget {
  CopyMoreProdutcsScreen({super.key});

  @override
  ConsumerState<CopyMoreProdutcsScreen> createState() =>
      _CopyMoreProdutcsScreenState();
}

class _CopyMoreProdutcsScreenState
    extends ConsumerState<CopyMoreProdutcsScreen> {
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  final _findIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Copy File", style: AppStyle.boldStyle()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: AppMargin(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBox(),
              AppSpacer(hp: .01),
              _buildSelectedIds(),
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectedIds() {
    final selectedProuducts = ref.watch(productIdSelectionControllerProvider);
    final selectedProuductsController = ref.read(
      productIdSelectionControllerProvider.notifier,
    );

    return selectedProuducts.selectedIds.isEmpty
        ? SizedBox()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selected Products", style: AppStyle.boldStyle()),
            Wrap(
              children:
                  selectedProuducts.selectedIds
                      .map(
                        (e) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              margin: EdgeInsets.only(
                                right: 8,
                                bottom: 5,
                                top: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.kTeal),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    e.toString(),
                                    style: AppStyle.boldStyle(
                                      color: AppColors.kTeal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              child: InkWell(
                                onTap: () {
                                  selectedProuductsController.remove(e);
                                },
                                child: Icon(
                                  SolarIconsBold.closeCircle,
                                  size: 18,
                                  color: AppColors.kErrorPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ],
        );
  }

  // List<int> similarProducts = [
  Widget _buildSearchBox() {
    final productSelectionState = ref.watch(
      productIdSelectionControllerProvider,
    );
    final controller = ref.read(productIdSelectionControllerProvider.notifier);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: TextField(
            controller: _findIDController,
            onChanged: (value) {
              _debouncer.run(() {
                controller.onSearchProduct(value);
              });
            },
            keyboardType: TextInputType.number,
            style: AppStyle.normalStyle(),
            cursorColor: AppColors.kBorderColor,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kErrorPrimary),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kErrorPrimary),
                borderRadius: BorderRadius.circular(10),
              ),
              errorText: productSelectionState.errorMessage,
              errorStyle: AppStyle.smallStyle(color: AppColors.kErrorPrimary),

              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              hintText: "Enter product id or scan QRcode",
              hintStyle: AppStyle.normalStyle(color: AppColors.kBorderColor),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(
                Icons.search,
                color:
                    productSelectionState.errorMessage != null
                        ? AppColors.kErrorPrimary
                        : AppColors.kBorderColor,
              ),
              suffixIcon:
                  productSelectionState.enableAddButton &&
                          productSelectionState.productModel != null
                      ? ZoomIn(
                        child: InkWell(
                          onTap: () {
                            controller.add(productSelectionState.productModel!);
                            _findIDController.clear();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10),
                              ),
                              color: AppColors.kDeepPurple,
                            ),

                            child: Icon(Icons.add, color: AppColors.kWhite),
                          ),
                        ),
                      )
                      : null,
            ),
          ),
        ),
        AppSpacer(wp: .01),
        InkWell(
          onTap: () {},
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: AppColors.kBorderColor),
            ),
            child: Icon(Icons.qr_code_2_rounded, color: AppColors.kBorderColor),
          ),
        ),
      ],
    );
  }
}
