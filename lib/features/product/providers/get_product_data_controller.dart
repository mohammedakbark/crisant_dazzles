import 'dart:async';

import 'package:dazzles/features/product/data/models/product_data_model.dart';

import 'package:dazzles/features/product/data/repo/get_product_data_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getProductDataControllerProvider =
    AsyncNotifierProvider<GetProductDataController, ProductDataModel>(
      GetProductDataController.new,
    );

class GetProductDataController extends AsyncNotifier<ProductDataModel> {
  @override
  FutureOr<ProductDataModel> build() async {
    try {
      state = AsyncValue.loading();
      final result = await GetProductDataRepo.onGetProductData();
      if (result['error'] == false) return result['data'];
      throw result['data'];
    } catch (e) {
      throw e.toString();
    }
  }
}
