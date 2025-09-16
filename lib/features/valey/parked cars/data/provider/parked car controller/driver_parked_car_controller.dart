import 'dart:async';
import 'dart:developer';

import 'package:dazzles/core/shared/models/pagination_model.dart';
import 'package:dazzles/features/valey/parked%20cars/data/model/driver_parked_car_model.dart';
import 'package:dazzles/features/valey/parked%20cars/data/model/driver_store_model.dart';
import 'package:dazzles/features/valey/parked%20cars/data/provider/parked%20car%20controller/all_parked_car_state.dart';
import 'package:dazzles/features/valey/parked%20cars/data/repo/driver_get_all_stores_repo.dart';
import 'package:dazzles/features/valey/parked%20cars/data/repo/get_all_list_of_parked_cars_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverParkedCarController extends AsyncNotifier<AllParkedCarState> {
  int _page = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  final TextEditingController _searchContollerFroAll = TextEditingController();
  TextEditingController get searchContollerFroAll => _searchContollerFroAll;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<AllParkedCarState> build() {
    try {
      return _fetchAllParkedCars();
    } catch (e) {
      throw e.toString();
    }
  }

  void _resetSearch() {
    _searchContollerFroAll.clear();

    _page = 1;
  }

  Future<AllParkedCarState> _fetchAllParkedCars() async {
    try {
      state = AsyncLoading();
      _resetSearch();
      await _onFetchStore();
      final result = await GetAllListOfParkedCarsRepo.onGetAllParkedCars(_page,
          storeId: null);
      if (result['error'] == false) {
        final stores = state.value?.storeList ?? [];
        final List<DriverParkedCarModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];
        _page++;
        _hasMore = pagination.hasMore;
        final updatedState = AllParkedCarState(
          selectedStore: null,
          storeList: stores,
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
      return state.value ?? AllParkedCarState(storeList: [], parkedCarList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<AllParkedCarState> _onFetchStore() async {
    try {
      state = AsyncLoading();
      final currentList = state.value?.parkedCarList ?? [];
      final result = await DriverGetAllStoresRepo.onGetAllStores();
      if (result['error'] == false) {
        final model = AllParkedCarState(
            selectedStore: null,
            parkedCarList: currentList,
            storeList: result['data']);
        log("Store Lenght => ${model.storeList.length}");
        state = AsyncValue.data(model);
        return model;
      } else {
        throw result['data'];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value ?? AllParkedCarState(storeList: [], parkedCarList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<AllParkedCarState> onSelectStore(DriverStoreModel newStore) async {
    try {
      state = AsyncLoading();

      _page = 0;
      final result = await GetAllListOfParkedCarsRepo.onGetAllParkedCars(_page,
          storeId: newStore.storeName == "All Store" ? null : newStore.storeId);
      if (result['error'] == false) {
        final stores = state.value?.storeList ?? [];
        final List<DriverParkedCarModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];
        _page++;
        _hasMore = pagination.hasMore;
        final updatedState = AllParkedCarState(
          selectedStore: newStore,
          storeList: stores,
          parkedCarList: fetched,
          isLoadingMore: false,
        );
        state = AsyncValue.data(updatedState);
        return updatedState;
      } else {
        final currentState = state.value;
        final updatedState = AllParkedCarState(
          selectedStore: newStore,
          storeList: currentState!.storeList,
          parkedCarList: [],
          isLoadingMore: false,
        );
        state = AsyncValue.data(updatedState);
        return updatedState;
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value ?? AllParkedCarState(storeList: [], parkedCarList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  //

  Future<AllParkedCarState> _loadMoree() async {
    if (_isLoadingMore)
      return state.value ??
          AllParkedCarState(
            storeList: [],
            parkedCarList: [],
          );

    try {
      _isLoadingMore = true;

      final currentList = state.value?.parkedCarList ?? [];
      final currentStores = state.value?.storeList ?? [];

      state = AsyncValue.data(
        state.value?.copyWith(isLoadingMore: true) ??
            AllParkedCarState(
                parkedCarList: currentList,
                storeList: currentStores,
                isLoadingMore: true),
      );
      // await Future.delayed(Duration(seconds: 3));

      final result = await GetAllListOfParkedCarsRepo.onGetAllParkedCars(_page);

      if (result['error'] == false) {
        final List<DriverParkedCarModel> fetched = result['data'];
        final PaginationModel pagination = result['pagination'];

        _page++;
        _hasMore = pagination.hasMore;

        final updatedList = [...currentList, ...fetched];
        final updatedState = AllParkedCarState(
          storeList: currentStores,
          parkedCarList: updatedList,
          isLoadingMore: false,
        );
        log(updatedList.length.toString());

        state = AsyncValue.data(updatedState);
        return updatedState;
      } else {
        throw result['data'];
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return state.value ?? AllParkedCarState(storeList: [], parkedCarList: []);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Load more products
  Future<void> loadMore() async {
    log("load more products ALL");
    if (!_hasMore) return;

    await _loadMoree();
  }
}

final drGetParkedCarListControllerProvider =
    AsyncNotifierProvider<DriverParkedCarController, AllParkedCarState>(
  DriverParkedCarController.new,
);
