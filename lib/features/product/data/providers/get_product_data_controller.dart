import 'dart:async';
import 'dart:developer';

import 'package:dazzles/features/product/data/models/product_data_model.dart';

import 'package:dazzles/features/product/data/repo/get_product_data_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getProductDataControllerProvider =
    AsyncNotifierProvider.family<GetProductDataController, ProductDataModel, int>(
  GetProductDataController.new,
);

class GetProductDataController extends FamilyAsyncNotifier<ProductDataModel,int> {
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
}
