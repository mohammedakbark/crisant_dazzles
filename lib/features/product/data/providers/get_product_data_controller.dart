import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/features/product/data/models/product_data_model.dart';

import 'package:dazzles/features/product/data/repo/get_product_data_repo.dart';
import 'package:dazzles/features/product/data/repo/update_sale_price_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final getProductDataControllerProvider = AsyncNotifierProvider.family<
    GetProductDataController, ProductDataModel, int>(
  GetProductDataController.new,
);

class GetProductDataController
    extends FamilyAsyncNotifier<ProductDataModel, int> {
  @override
  FutureOr<ProductDataModel> build(int id) async {
    try {
      state = AsyncValue.loading();
      final result = await GetProductDataRepo.onGetProductData(id);

      if (result['error'] == false) return result['data'];
      throw result['data'];
    } catch (e) {
      // log(e.toString());
      throw e.toString();
    }
  }

  Future<bool> onUpdateProduct(
      String productId, String price, BuildContext context) async {
    try {
      final result =
          await UpdateSalePriceRepo.onUpdateSalePrice(productId, price);
      log(result.toString());

      if (result['error'] == false) {
        // Safely get the current loaded model (if any)
        final currentData = state.asData?.value;

        if (currentData != null) {
          // Try to use `copyWith` if available, otherwise mutate the model field and re-wrap.
          currentData.productSellingPrice = result['data'];
          state = AsyncData(currentData);
        }

        showCustomSnackBarAdptive("Price updated successfully!",
            isError: false);
        // Only pop/close the UI after a successful update
        context.pop();
        return true;
      } else {
        showCustomSnackBarAdptive(result['message'], isError: true);
        return false;
      }
    } catch (e) {
      showCustomSnackBarAdptive(e.toString(), isError: true);
      return false;
    }
  }
}
