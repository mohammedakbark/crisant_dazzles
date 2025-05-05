import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/product/data/repo/get_all_products_repo.dart';
import 'package:dazzles/features/upload/data/repo/get_pending_products_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllPendingProductControllerProvider =
    AsyncNotifierProvider<GetPendingProductsController, List<ProductModel>>(
      GetPendingProductsController.new,
    );

class GetPendingProductsController extends AsyncNotifier<List<ProductModel>> {
  int _page = 1;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  // @override
  // FutureOr<List<ProductModel>> build() async {
  //   try {
  //     state = AsyncValue.loading();
  //     final result = await GetPendingProductsRepo.onGetAllPendingProducts(
  //       _page,
  //     );
  //     if (result['error'] == false) return result['data'];
  //     throw result['data'];
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  @override
  FutureOr<List<ProductModel>> build() async {
    state = AsyncValue.loading();
    return await _fetchProducts(reset: true);
  }

  Future<List<ProductModel>> _fetchProducts({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    try {
      _isLoadingMore = true;
      if (reset) {
        _page = 1;
      }
      final result = await GetPendingProductsRepo.onGetAllPendingProducts(
        _page,
      );
      if (result['error'] == false) {
        final fetchedProducts = result['data'] as List<ProductModel>;
        final paginationData = result['pagination'] as PaginationModel;
        List<ProductModel> oldProducts = reset ? [] : state.value ?? [];
        _page++;
        _hasMore = paginationData.hasMore;
        final newProducts = [...oldProducts, ...fetchedProducts];
        log(newProducts.length.toString());
        state = AsyncValue.data(newProducts);
        return newProducts;
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? [];
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMore() async {
    if (_hasMore) {
      await _fetchProducts();
    }
  }
}
