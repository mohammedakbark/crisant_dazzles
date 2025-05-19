import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/pending/data/repo/get_pending_products_repo.dart';
import 'package:dazzles/features/pending/data/providers/get%20pending%20products/pending_products_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllPendingProductControllerProvider = AsyncNotifierProvider<
  GetPendingProductsController,
  PendingProductSuccessState
>(GetPendingProductsController.new);

class GetPendingProductsController
    extends AsyncNotifier<PendingProductSuccessState> {
  int _page = 1;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<PendingProductSuccessState> build() async {
    try {
      state = AsyncValue.loading();
      return await _fetchProducts();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PendingProductSuccessState> _fetchProducts() async {
    try {
      _page = 1;
      _isLoadingMore = false;

      final result = await GetPendingProductsRepo.onGetAllPendingProducts(
        _page,
      );
      if (result['error'] == false) {
        final fetchedProducts = result['data'] as List<ProductModel>;
        final paginationData = result['pagination'] as PaginationModel;

        _page++;
        _hasMore = paginationData.hasMore;

        state = AsyncValue.data(
          PendingProductSuccessState(products: fetchedProducts),
        );
        return PendingProductSuccessState(products: fetchedProducts);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? PendingProductSuccessState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<PendingProductSuccessState> _loadMore() async {
    if (_isLoadingMore) {
      return state.value ?? PendingProductSuccessState(products: []);
    }

    try {
      _isLoadingMore = true;

      final currentProducts = state.value?.products ?? [];
      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            PendingProductSuccessState(
              products: currentProducts,
              isLoadingMore: true,
            ),
      );
      final result = await GetPendingProductsRepo.onGetAllPendingProducts(
        _page,
      );
      if (result['error'] == false) {
        final fetchedProducts = result['data'] as List<ProductModel>;
        final paginationData = result['pagination'] as PaginationModel;
        List<ProductModel> oldProducts = currentProducts;
        _page++;
        _hasMore = paginationData.hasMore;
        final newProducts = [...oldProducts, ...fetchedProducts];
        log(newProducts.length.toString());
        state = AsyncValue.data(
          PendingProductSuccessState(products: newProducts),
        );
        return PendingProductSuccessState(products: newProducts);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? PendingProductSuccessState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMore() async {
    if (_hasMore) {
      await _loadMore();
    }
  }
}
