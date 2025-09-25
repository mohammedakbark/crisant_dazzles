import 'dart:async';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/features/navigation/data/model/upcoming_product_model.dart';
import 'package:dazzles/features/navigation/data/provider/upcoming%20product%20controller/upcoming_product_state.dart';
import 'package:dazzles/features/navigation/data/repo/get_up_coming_products_list_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final upcomingProductsControllerProvider =
    AsyncNotifierProvider<GetUpcomingProductsController, UpcomingProductState>(
  GetUpcomingProductsController.new,
);

class GetUpcomingProductsController
    extends AsyncNotifier<UpcomingProductState> {
  int _page = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  @override
  Future<UpcomingProductState> build() async {
    try {
      return _fetchUpcomingProducts();
    } catch (e) {
      throw e.toString();
    }
  }

  void _resetSearch() {
    _page = 1;
  }

  Future<UpcomingProductState> _fetchUpcomingProducts() async {
    try {
      state = AsyncLoading();
      _resetSearch();

      final result =
          await GetUpComingProductsListRepo.onGetUpcomingProducts(_page);
      if (result['error'] == false) {
        final List<UpcomingProductsModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];
        _page++;
        _hasMore = pagination.hasMore;
        final updatedState = UpcomingProductState(
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
      return state.value ?? UpcomingProductState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<UpcomingProductState> loadMore() async {
    if (_isLoadingMore)
      return state.value ?? UpcomingProductState(products: []);

    try {
      _isLoadingMore = true;

      final currentProducts = state.value?.products ?? [];

      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            UpcomingProductState(
                products: currentProducts, isLoadingMore: true),
      );

      final result =
          await GetUpComingProductsListRepo.onGetUpcomingProducts(_page);

      if (result['error'] == false) {
        final List<UpcomingProductsModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];

        _page++;
        _hasMore = pagination.hasMore;

        final updatedList = [...currentProducts, ...fetched];
        final updatedState = UpcomingProductState(
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
      return state.value ?? UpcomingProductState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }
}
