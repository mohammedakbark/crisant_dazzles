import 'dart:async';
import 'dart:developer';

import 'package:dazzles/office/product/data/providers/product_controller/product_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/office/product/data/models/product_model.dart';
import 'package:dazzles/office/product/data/repo/get_all_products_repo.dart';
import 'package:dazzles/office/product/data/repo/search_product_repo.dart';

/// Riverpod Provider
final allProductControllerProvider =
    AsyncNotifierProvider<GetProductsController, ProductSuccessState>(
      GetProductsController.new,
    );

/// State Class

/// Controller Class
class GetProductsController extends AsyncNotifier<ProductSuccessState> {
  int _page = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  bool _isSearchEnabled = false;
  bool _isSearching = false;
  String _query = "";

  final TextEditingController _searchContoller = TextEditingController();
  TextEditingController get searchContoller => _searchContoller;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => _isSearching;

  @override
  Future<ProductSuccessState> build() async {
    try {
      return _fetchProducts();
    } catch (e) {
      throw e.toString();
    }
  }

  void _resetSearch() {
    _query = "";
    _searchContoller.clear();
    _isSearchEnabled = false;
    _isSearching = false;
    _page = 1;
  }

  Future<ProductSuccessState> _fetchProducts() async {
    try {
      state = AsyncLoading();
      _resetSearch();

      final result = await GetAllProductsRepo.onGetAllProducts(_page);
      if (result['error'] == false) {
        final List<ProductModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];
        _page++;
        _hasMore = pagination.hasMore;
        final updatedState = ProductSuccessState(
          products: fetched,
          isLoadingMore: false,
        );
        state = AsyncValue.data(updatedState);
        return updatedState;
      } else {
        throw result['data'];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value ?? ProductSuccessState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Fetch product list (initial or paginated)
  Future<ProductSuccessState> _loadMoreProductsFromAll() async {
    if (_isLoadingMore) return state.value ?? ProductSuccessState(products: []);

    try {
      _isLoadingMore = true;

      final currentProducts = state.value?.products ?? [];

      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            ProductSuccessState(products: currentProducts, isLoadingMore: true),
      );

      final result = await GetAllProductsRepo.onGetAllProducts(_page);

      if (result['error'] == false) {
        final List<ProductModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];

        _page++;
        _hasMore = pagination.hasMore;

        final updatedList = [...currentProducts, ...fetched];
        final updatedState = ProductSuccessState(
          products: updatedList,
          isLoadingMore: false,
        );

        state = AsyncValue.data(updatedState);
        return updatedState;
      } else {
        throw result['data'];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value ?? ProductSuccessState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Load more products
  Future<void> loadMore() async {
    log("load more products");
    if (!_hasMore) return;

    if (_isSearchEnabled && _query.isNotEmpty) {
      await _loadMoreSearchResults();
    } else {
      await _loadMoreProductsFromAll();
    }
  }

  /// Search products
  Future<List<ProductModel>> onSearchProduct(String query) async {
    _query = query;
    _page = 1;
    _hasMore = false;
    _isSearchEnabled = query.isNotEmpty;

    if (_isLoadingMore) return state.value?.products ?? [];

    if (query.isEmpty) {
      return (await _fetchProducts()).products;
    }

    try {
      _isLoadingMore = true;
      _isSearching = true;

      final result = await SearchProductRepo.onSearchProduct(_page, query);
      _isSearching = false;

      if (result['error'] == false) {
        final List<ProductModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];

        _page++;
        _hasMore = pagination.hasMore;

        final newState = ProductSuccessState(
          products: fetched,
          isLoadingMore: false,
        );

        state = AsyncValue.data(newState);
        return fetched;
      } else {
        throw result['data'];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value?.products ?? [];
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Load more for search result
  Future<List<ProductModel>> _loadMoreSearchResults() async {
    if (_isLoadingMore || _query.isEmpty) return state.value?.products ?? [];

    try {
      _isLoadingMore = true;
      final current = state.value?.products ?? [];
      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            ProductSuccessState(products: current, isLoadingMore: true),
      );
      final result = await SearchProductRepo.onSearchProduct(_page, _query);

      if (result['error'] == false) {
        final List<ProductModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];

        _page++;
        _hasMore = pagination.hasMore;

        final updatedList = [...current, ...fetched];
        final newState = ProductSuccessState(
          products: updatedList,
          isLoadingMore: false,
        );

        state = AsyncValue.data(newState);
        return updatedList;
      } else {
        throw result['data'];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value?.products ?? [];
    } finally {
      _isLoadingMore = false;
    }
  }
}
