import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/module/office/packaging/data/model/po_product_model.dart';
import 'package:dazzles/module/office/packaging/data/provider/get%20po%20products/po_products_state.dart';
import 'package:dazzles/module/office/packaging/data/repo/get_po_products_repo.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider with `.family` to allow passing `id` when fetching data
final getAllPoProductsControllerProvider = AsyncNotifierProvider.family<
    GetPoProductsController, PoProductsSuccessState, String>(
  GetPoProductsController.new,
);

class GetPoProductsController
    extends FamilyAsyncNotifier<PoProductsSuccessState, String> {
  int _page = 1;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<PoProductsSuccessState> build(String id) async {
    state = const AsyncValue.loading();
    return await _fetchPOProducts(id, resetPage: true);
  }

  /// Fetch products (first page or refresh)
  Future<PoProductsSuccessState> _fetchPOProducts(
    String id, {
    bool resetPage = false,
  }) async {
    try {
      if (resetPage) {
        _page = 1;
        _isLoadingMore = false;
      }

      final result = await GetPoProductsRepo.onGetPoProducts(
        _page,
        int.parse(id),
      );

      if (result['error'] == false) {
        final fetchedProducts = result['data'] as List<PoProductModel>;
        final paginationData = result['pagination'] as PaginationModel;

        _page++;
        _hasMore = paginationData.hasMore;

        state = AsyncValue.data(
          PoProductsSuccessState(poProducts: fetchedProducts),
        );
        return PoProductsSuccessState(poProducts: fetchedProducts);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      log(e.toString());
      return state.value ?? PoProductsSuccessState(poProducts: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Load more products (next page)
  Future<PoProductsSuccessState> _loadMore(String id) async {
    if (_isLoadingMore || !_hasMore) {
      return state.value ?? PoProductsSuccessState(poProducts: []);
    }

    try {
      _isLoadingMore = true;

      final currentProducts = state.value?.poProducts ?? [];
      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            PoProductsSuccessState(
              poProducts: currentProducts,
              isLoadingMore: true,
            ),
      );

      final result = await GetPoProductsRepo.onGetPoProducts(
        _page,
        int.parse(id),
      );

      if (result['error'] == false) {
        final fetchedProducts = result['data'] as List<PoProductModel>;
        final paginationData = result['pagination'] as PaginationModel;

        _page++;
        _hasMore = paginationData.hasMore;

        final newProducts = [...currentProducts, ...fetchedProducts];
        log("Loaded total products: ${newProducts.length}");

        state = AsyncValue.data(
          PoProductsSuccessState(poProducts: newProducts),
        );
        return PoProductsSuccessState(poProducts: newProducts);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? PoProductsSuccessState(poProducts: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Public method to trigger load more
  Future<void> loadMore(String id) async {
    if (_hasMore) {
      await _loadMore(id);
    }
  }

  /// Public method to refresh list
  Future<void> refresh(String id) async {
    await _fetchPOProducts(id, resetPage: true);
  }

  void onSelectProducts(int id) {
    HapticFeedback.selectionClick();
    List<int> selectedIds = List<int>.from(state.value?.selectedIds ?? []);
    bool isSelectionEnabled = state.value?.isSelectionEnabled ?? false;

    if (isSelectionEnabled) {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }

      if (selectedIds.isEmpty) {
        isSelectionEnabled = false;
      }

      state = AsyncValue.data(
        state.value?.copyWith(
                selectedIds: selectedIds,
                isSelectionEnabled: isSelectionEnabled) ??
            PoProductsSuccessState(
              isSelectionEnabled: isSelectionEnabled,
              poProducts: [],
              selectedIds: selectedIds, // ensure passing updated list
            ),
      );
    }
  }

  void onEnableSelection({int? id}) {
    HapticFeedback.heavyImpact();
    List<int> selectedIds = List<int>.from(state.value?.selectedIds ?? []);

    bool isSelectionEnabled = state.value?.isSelectionEnabled ?? false;
    isSelectionEnabled = !isSelectionEnabled;
    if (isSelectionEnabled && id != null) {
      selectedIds.add(id);
    }
    if (!isSelectionEnabled) {
      selectedIds.clear();
    }
    state = AsyncValue.data(
      state.value?.copyWith(
              isSelectionEnabled: isSelectionEnabled,
              selectedIds: selectedIds) ??
          PoProductsSuccessState(
            selectedIds: selectedIds,
            isSelectionEnabled: isSelectionEnabled,
            poProducts: [],
            isLoadingMore: false,
          ),
    );
  }
}
