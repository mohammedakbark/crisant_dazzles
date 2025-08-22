import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/module/office/packaging/data/model/supplier_model.dart';
import 'package:dazzles/module/office/packaging/data/provider/get%20suppliers/suppliers_state.dart';
import 'package:dazzles/module/office/packaging/data/repo/get_po_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllSuppliersControllerProvider =
    AsyncNotifierProvider<GetSuppliersController, SuppliersSuccessState>(
        GetSuppliersController.new);

class GetSuppliersController extends AsyncNotifier<SuppliersSuccessState> {
  int _page = 1;
  bool _hasMore = false;
  bool get hasMore => _hasMore;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  String? _query;

  @override
  FutureOr<SuppliersSuccessState> build() async {
    try {
      state = AsyncValue.loading();
      return await _fetchPurchaseOrders();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SuppliersSuccessState> _fetchPurchaseOrders() async {
    try {
      _page = 1;
      _query = null;
      _isLoadingMore = false;

      final result = await GetPoRepo.onGetAllPos(_page, _query);
      if (result['error'] == false) {
        final fetchedPos = result['data'] as List<SupplierModel>;
        final paginationData = result['pagination'] as PaginationModel;

        _page++;
        _hasMore = paginationData.hasMore;

        state = AsyncValue.data(
          SuppliersSuccessState(purchaseOrderList: fetchedPos),
        );
        return SuppliersSuccessState(purchaseOrderList: fetchedPos);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? SuppliersSuccessState(purchaseOrderList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<SuppliersSuccessState> _loadMore() async {
    if (_isLoadingMore) {
      return state.value ?? SuppliersSuccessState(purchaseOrderList: []);
    }

    try {
      _isLoadingMore = true;

      final currentPos = state.value?.purchaseOrderList ?? [];
      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            SuppliersSuccessState(
              purchaseOrderList: currentPos,
              isLoadingMore: true,
            ),
      );
      final result = await GetPoRepo.onGetAllPos(_page, _query);
      if (result['error'] == false) {
        final fetchedPos = result['data'] as List<SupplierModel>;
        final paginationData = result['pagination'] as PaginationModel;
        List<SupplierModel> oldPos = currentPos;
        _page++;
        _hasMore = paginationData.hasMore;
        final newPos = [...oldPos, ...fetchedPos];
        log(newPos.length.toString());
        state = AsyncValue.data(
          SuppliersSuccessState(purchaseOrderList: newPos),
        );
        return SuppliersSuccessState(purchaseOrderList: newPos);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? SuppliersSuccessState(purchaseOrderList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMore() async {
    if (_hasMore) {
      await _loadMore();
    }
  }

  // Search

  Future<SuppliersSuccessState> onSearch(String query) async {
    try {
      _query = query;
      _page = 1;
      _isLoadingMore = false;

      final result = await GetPoRepo.onGetAllPos(_page, _query);
      if (result['error'] == false) {
        final fetchedPos = result['data'] as List<SupplierModel>;
        final paginationData = result['pagination'] as PaginationModel;

        _page++;
        _hasMore = paginationData.hasMore;
        log(fetchedPos.length.toString());
        state = AsyncValue.data(
          SuppliersSuccessState(purchaseOrderList: fetchedPos),
        );
        return SuppliersSuccessState(purchaseOrderList: fetchedPos);
      } else {
        throw result['data'];
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return state.value ?? SuppliersSuccessState(purchaseOrderList: []);
    } finally {
      _isLoadingMore = false;
    }
  }
}
