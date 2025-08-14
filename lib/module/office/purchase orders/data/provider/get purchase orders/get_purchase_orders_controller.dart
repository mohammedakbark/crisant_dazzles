import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/module/office/purchase%20orders/data/model/po_model.dart';
import 'package:dazzles/module/office/purchase%20orders/data/provider/get%20purchase%20orders/po_state.dart';
import 'package:dazzles/module/office/purchase%20orders/data/repo/get_po_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllProductOrdersControllerProvider =
    AsyncNotifierProvider<GetPurchaseOrdersController, POSuccessState>(
        GetPurchaseOrdersController.new);

class GetPurchaseOrdersController extends AsyncNotifier<POSuccessState> {
  int _page = 1;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<POSuccessState> build() async {
    try {
      state = AsyncValue.loading();
      return await _fetchPurchaseOrders();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<POSuccessState> _fetchPurchaseOrders() async {
    try {
      _page = 1;
      _isLoadingMore = false;

      final result = await GetPoRepo.onGetAllPos(
        _page,
      );
      if (result['error'] == false) {
        final fetchedPos = result['data'] as List<PoModel>;
        final paginationData = result['pagination'] as PaginationModel;

        _page++;
        _hasMore = paginationData.hasMore;

        state = AsyncValue.data(
          POSuccessState(purchaseOrderList: fetchedPos),
        );
        return POSuccessState(purchaseOrderList: fetchedPos);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? POSuccessState(purchaseOrderList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<POSuccessState> _loadMore() async {
    if (_isLoadingMore) {
      return state.value ?? POSuccessState(purchaseOrderList: []);
    }

    try {
      _isLoadingMore = true;

      final currentPos = state.value?.purchaseOrderList ?? [];
      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            POSuccessState(
              purchaseOrderList: currentPos,
              isLoadingMore: true,
            ),
      );
      final result = await GetPoRepo.onGetAllPos(
        _page,
      );
      if (result['error'] == false) {
        final fetchedPos = result['data'] as List<PoModel>;
        final paginationData = result['pagination'] as PaginationModel;
        List<PoModel> oldPos = currentPos;
        _page++;
        _hasMore = paginationData.hasMore;
        final newPos = [...oldPos, ...fetchedPos];
        log(newPos.length.toString());
        state = AsyncValue.data(
          POSuccessState(purchaseOrderList: newPos),
        );
        return POSuccessState(purchaseOrderList: newPos);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? POSuccessState(purchaseOrderList: []);
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
