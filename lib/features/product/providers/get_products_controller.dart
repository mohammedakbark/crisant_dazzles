import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/product/data/repo/get_all_products_repo.dart';
import 'package:dazzles/features/product/data/repo/search_product_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allProductControllerProvider =
    AsyncNotifierProvider<GetProductsController, List<ProductModel>>(
      GetProductsController.new,
    );

class GetProductsController extends AsyncNotifier<List<ProductModel>> {
  int _page = 1;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _isSerchEnabled = false;
  bool get isSerchEnabled => _isSerchEnabled;

  @override
  FutureOr<List<ProductModel>> build() async {
    state = AsyncValue.loading();
    _isSerchEnabled = false;
    return await _fetchProducts(reset: true);
  }

  Future<List<ProductModel>> _fetchProducts({bool reset = false}) async {
    _isSerchEnabled = true;
    if (_isLoadingMore) return state.value ?? [];

    try {
      _isLoadingMore = true;
      if (reset) {
        _page = 1;
      }
      final result = await GetAllProductsRepo.onGetAllProducts(_page);
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
      if (_isSerchEnabled) {
        onSearchProduct(_query);
      } else {
        await _fetchProducts();
      }
    }
  }

  String _query = "";
  Future<List<ProductModel>> onSearchProduct(String query) async {
    final oldState = state;
    state = AsyncValue.loading();
    _query = query;
    if (_isLoadingMore) return state.value ?? [];
    if (query.isEmpty) return oldState.value ?? [];

    try {
      _isLoadingMore = true;
      final result = await SearchProductRepo.onSearchProduct(_page, query);
      if (result['error'] == false) {
        final fetchedProducts = result['data'] as List<ProductModel>;
        final paginationData = result['pagination'] as PaginationModel;
        // List<ProductModel> oldProducts = reset ? [] : state.value ?? [];
        _page++;
        _hasMore = paginationData.hasMore;

        log(fetchedProducts.length.toString());
        state = AsyncValue.data(fetchedProducts);
        return fetchedProducts;
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
}
