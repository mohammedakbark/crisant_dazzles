import 'dart:developer';

import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/data/repo/search_product_by_id_repo.dart';
import 'package:dazzles/features/upload/providers/select%20product%20controller/product_selection_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductIdSelectionController extends Notifier<ProductSelectionState> {
  @override
  ProductSelectionState build() {
    return ProductSelectionState(
      enableAddButton: false,
      errorMessage: null,
      selectedIds: [],
      productModel: null,
    );
  }

  void add(ProductModel id) {
    final ids = state.selectedIds;
    if (!ids.contains(id)) {
      state = state.copyWith(
        errorMessage: null,
        selectedIds: [...state.selectedIds, id],
      );
    }
  }

  void remove(ProductModel id) {
    final ids = state.selectedIds;
    state = state.copyWith(
      errorMessage: null,
      selectedIds: ids.where((element) => element != id).toList(),
    );
  }

  void onSearchProduct(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        enableAddButton: false,
        errorMessage: null,
        productModel: null,
      );
    } else {
      final respnse = await SearchProductByIdRepo.onSearchProductById(query);
      if (respnse['error'] == false) {
        state = state.copyWith(
          enableAddButton: true,
          errorMessage: null,
          productModel: respnse['data'],
        );
      } else {
        state = state.copyWith(
          enableAddButton: false,
          errorMessage: respnse['data'],
          productModel: null,
        );
      }
    }
  }
}

final productIdSelectionControllerProvider =
    NotifierProvider<ProductIdSelectionController, ProductSelectionState>(() {
      return ProductIdSelectionController();
    });
