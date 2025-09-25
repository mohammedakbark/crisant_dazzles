import 'dart:async';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/features/navigation/data/model/image_pending_product_model.dart';
import 'package:dazzles/features/navigation/data/provider/image%20pending%20controller/image_pending_state.dart';
import 'package:dazzles/features/navigation/data/repo/get_image_pending_list_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imagePendingControllerProvider =
    AsyncNotifierProvider<GetImagePendingController, ImagePendingState>(
  GetImagePendingController.new,
);

class GetImagePendingController extends AsyncNotifier<ImagePendingState> {
  int _page = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<ImagePendingState> build() async {
    try {
      return _fetchUpcomingProducts();
    } catch (e) {
      throw e.toString();
    }
  }

  void _resetSearch() {
    _page = 1;
  }

  Future<ImagePendingState> _fetchUpcomingProducts() async {
    try {
      state = AsyncLoading();
      _resetSearch();

      final result = await GetImagePendingListRepo.onGetImagePendingList(_page);
      if (result['error'] == false) {
        final List<ImagePendingProductsModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];
        _page++;
        _hasMore = pagination.hasMore;
        final updatedState = ImagePendingState(
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
      return state.value ?? ImagePendingState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<ImagePendingState> loadMore() async {
    if (_isLoadingMore) return state.value ?? ImagePendingState(products: []);

    try {
      _isLoadingMore = true;

      final currentProducts = state.value?.products ?? [];

      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            ImagePendingState(products: currentProducts, isLoadingMore: true),
      );

      final result = await GetImagePendingListRepo.onGetImagePendingList(_page);

      if (result['error'] == false) {
        final List<ImagePendingProductsModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];

        _page++;
        _hasMore = pagination.hasMore;

        final updatedList = [...currentProducts, ...fetched];
        final updatedState = ImagePendingState(
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
      return state.value ?? ImagePendingState(products: []);
    } finally {
      _isLoadingMore = false;
    }
  }
}
