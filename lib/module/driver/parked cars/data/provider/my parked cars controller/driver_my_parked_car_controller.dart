import 'dart:async';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/my_parked_car_state.dart';
import 'package:dazzles/module/driver/parked%20cars/data/repo/get_my_parked_list_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverParkedCarController extends AsyncNotifier<MyParkedCarState> {
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
  FutureOr<MyParkedCarState> build() {
    try {
      return _fetchMyParkedCars();
    } catch (e) {
      throw e.toString();
    }
  }

  void _resetSearchForAll() {
    _query = "";
    _searchContoller.clear();
    _isSearchEnabled = false;
    _isSearching = false;
    _page = 1;
  }

  Future<MyParkedCarState> _fetchMyParkedCars() async {
    try {
      state = AsyncLoading();
      _resetSearchForAll();

      final result = await GetMyParkedListRepo.onGetMyParkedList(_page);
      if (result['error'] == false) {
        final List<DriverParkedCarModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];
        _page++;
        _hasMore = pagination.hasMore;
        final updatedState = MyParkedCarState(
          parkedCarList: fetched,
          isLoadingMore: false,
        );
        state = AsyncValue.data(updatedState);
        return updatedState;
      } else {
        throw result['data'];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value ?? MyParkedCarState(parkedCarList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  // Future<ProductSuccessState> _loadMoreProductsFromAll() async {
  //   if (_isLoadingMore) return state.value ?? ProductSuccessState(products: []);

  //   try {
  //     _isLoadingMore = true;

  //     final currentProducts = state.value?.products ?? [];

  //     state = AsyncValue.data(
  //       state.value?.copyWith(isLoadingMore: true) ??
  //           ProductSuccessState(products: currentProducts, isLoadingMore: true),
  //     );

  //     final result = await GetAllProductsRepo.onGetAllProducts(_page);

  //     if (result['error'] == false) {
  //       final List<ProductModel> fetched = result['data'];
  //       final PaginationModel pagination = result['pagination'];

  //       _page++;
  //       _hasMore = pagination.hasMore;

  //       final updatedList = [...currentProducts, ...fetched];
  //       final updatedState = ProductSuccessState(
  //         products: updatedList,
  //         isLoadingMore: false,
  //       );

  //       state = AsyncValue.data(updatedState);
  //       return updatedState;
  //     } else {
  //       throw result['data'];
  //     }
  //   } catch (e, stack) {
  //     state = AsyncValue.error(e, stack);
  //     return state.value ?? ProductSuccessState(products: []);
  //   } finally {
  //     _isLoadingMore = false;
  //   }
  // }

  // /// Load more products
  // Future<void> loadMore() async {
  //   log("load more products");
  //   if (!_hasMore) return;

  //   if (_isSearchEnabled && _query.isNotEmpty) {
  //     await _loadMoreSearchResults();
  //   } else {
  //     await _loadMoreProductsFromAll();
  //   }
  // }

  // /// Search products
  // Future<List<ProductModel>> onSearchProduct(String query) async {
  //   _query = query;
  //   _page = 1;
  //   _hasMore = false;
  //   _isSearchEnabled = query.isNotEmpty;

  //   if (_isLoadingMore) return state.value?.products ?? [];

  //   if (query.isEmpty) {
  //     return (await _fetchProducts()).products;
  //   }

  //   try {
  //     _isLoadingMore = true;
  //     _isSearching = true;

  //     final result = await SearchProductRepo.onSearchProduct(_page, query);
  //     _isSearching = false;

  //     if (result['error'] == false) {
  //       final List<ProductModel> fetched = result['data'];
  //       final PaginationModel pagination = result['pagination'];

  //       _page++;
  //       _hasMore = pagination.hasMore;

  //       final newState = ProductSuccessState(
  //         products: fetched,
  //         isLoadingMore: false,
  //       );

  //       state = AsyncValue.data(newState);
  //       return fetched;
  //     } else {
  //       throw result['data'];
  //     }
  //   } catch (e, stack) {
  //     state = AsyncValue.error(e, stack);
  //     return state.value?.products ?? [];
  //   } finally {
  //     _isLoadingMore = false;
  //   }
  // }

  // /// Load more for search result
  // Future<List<ProductModel>> _loadMoreSearchResults() async {
  //   if (_isLoadingMore || _query.isEmpty) return state.value?.products ?? [];

  //   try {
  //     _isLoadingMore = true;
  //     final current = state.value?.products ?? [];
  //     state = AsyncValue.data(
  //       state.value?.copyWith(isLoadingMore: true) ??
  //           ProductSuccessState(products: current, isLoadingMore: true),
  //     );
  //     final result = await SearchProductRepo.onSearchProduct(_page, _query);

  //     if (result['error'] == false) {
  //       final List<ProductModel> fetched = result['data'];
  //       final PaginationModel pagination = result['pagination'];

  //       _page++;
  //       _hasMore = pagination.hasMore;

  //       final updatedList = [...current, ...fetched];
  //       final newState = ProductSuccessState(
  //         products: updatedList,
  //         isLoadingMore: false,
  //       );

  //       state = AsyncValue.data(newState);
  //       return updatedList;
  //     } else {
  //       throw result['data'];
  //     }
  //   } catch (e, stack) {
  //     state = AsyncValue.error(e, stack);
  //     return state.value?.products ?? [];
  //   } finally {
  //     _isLoadingMore = false;
  //   }
  // }
}

final drGetMyParkedCarListControllerProvider =
    AsyncNotifierProvider<DriverParkedCarController, MyParkedCarState>(
  DriverParkedCarController.new,
);
