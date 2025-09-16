import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/features/valey/parked%20cars/data/model/driver_parked_car_model.dart';
import 'package:dazzles/features/valey/parked%20cars/data/provider/my%20parked%20cars%20controller/my_parked_car_state.dart';
import 'package:dazzles/features/valey/parked%20cars/data/repo/get_my_parked_list_repo.dart';
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

  Future<MyParkedCarState> _loadMoree() async {
    if (_isLoadingMore)
      return state.value ??
          MyParkedCarState(
            parkedCarList: [],
          );

    try {
      _isLoadingMore = true;

      final currentList = state.value?.parkedCarList ?? [];

      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            MyParkedCarState(parkedCarList: currentList, isLoadingMore: true),
      );

      final result = await GetMyParkedListRepo.onGetMyParkedList(_page);

      if (result['error'] == false) {
        final List<DriverParkedCarModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];

        _page++;
        _hasMore = pagination.hasMore;

        final updatedList = [...currentList, ...fetched];
        final updatedState = MyParkedCarState(
          parkedCarList: updatedList,
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

  /// Load more products
  Future<void> loadMore() async {
    log("load more products MY");
    if (!_hasMore) return;

    await _loadMoree();
  }
}

final drGetMyParkedCarListControllerProvider =
    AsyncNotifierProvider<DriverParkedCarController, MyParkedCarState>(
  DriverParkedCarController.new,
);
