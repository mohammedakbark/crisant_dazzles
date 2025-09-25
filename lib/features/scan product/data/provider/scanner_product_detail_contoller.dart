import 'dart:async';
import 'dart:developer';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/utils/snackbars.dart';
import 'package:dazzles/features/scan%20product/data/model/scanned_product_model.dart';
import 'package:dazzles/features/scan%20product/data/provider/scanned_product_state.dart';
import 'package:dazzles/features/scan%20product/data/repo/get_product_details_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Define the provider with family
final scannerProductDetailProvider = AsyncNotifierProviderFamily<
    ScannerProductDetailController, ScannedProductState, Map<String, dynamic>>(
  () => ScannerProductDetailController(),
);

class ScannerProductDetailController
    extends FamilyAsyncNotifier<ScannedProductState, Map<String, dynamic>> {
  @override
  FutureOr<ScannedProductState> build(Map<String, dynamic> parms) {
    return fetchProductDetails(parms['context'], parms['productId']);
  }

  Future<ScannedProductState> fetchProductDetails(
      BuildContext context, String productId) async {
    try {
      HapticFeedback.heavyImpact();
      state = const AsyncValue.loading();

      final response = await GetProductDetailsRepo.onGetDetials(productId);
      log(response.toString());
      if (response['error'] == false) {
        // log(response['data'].toString());
        final product = response['data'] as ScannedProductModel;
        context.pushReplacement(scannedProductDetailScreen, extra: product.toJson());
        // context.push(scannedProductDetailScreen, extra: product.toJson());
        return ScannedProductLoaded(product);
      } else {
        showCustomSnackBarAdptive(response['data'], isError: true);
        return ScannedProductError(response['data']);
      }
    } catch (e) {
      log(e.toString());
      showCustomSnackBarAdptive(e.toString(), isError: true);
      return ScannedProductError(e.toString());
    }
  }
}
