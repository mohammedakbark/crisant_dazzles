import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/constant/app_images.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/data/repo/search_product_by_id_repo.dart';
import 'package:dazzles/features/upload/providers/select%20&%20search%20product/product_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectAndSearchProductController extends Notifier<ProductSelectionState> {
  @override
  ProductSelectionState build() {
    return ProductSelectionState(
      enableAddButton: false,
      errorMessage: null,
      selectedIds: [],
      productModel: null,
    );
  }

  void add(
    ProductModel model,
    BuildContext context, {
    Function(VoidCallback onCancel, VoidCallback onReplace)? showSheet,
  }) async {
    final models = state.selectedIds;

    if (!models.any((element) => element.id == model.id)) {
      if (model.productPicture != null && showSheet != null) {
        showSheet(
          () {
            state = state.copyWith(errorMessage: null, enableAddButton: false);
            context.pop();
          },
          () {
            state = state.copyWith(
              errorMessage: null,
              selectedIds: [...state.selectedIds, model],
            );
            context.pop();
          },
        );
        // _showReplacePicutreConfirmation(
        //   context: context,
        //   currentImage: model.productPicture!,
        //   newImage: newImage,
        //   onCanel: () {
        //     state = state.copyWith(errorMessage: null, enableAddButton: false);
        //     context.pop();
        //   },
        //   onReplace: () {
        //     state = state.copyWith(
        //       errorMessage: null,
        //       selectedIds: [...state.selectedIds, model],
        //     );
        //     context.pop();
        //   },
        // );
      } else {
        state = state.copyWith(
          errorMessage: null,
          selectedIds: [...state.selectedIds, model],
        );
      }
    } else {
      state = state.copyWith(errorMessage: "Already exist");
      await disableErrro();
    }
  }

  Future<void> disableErrro() async {
    await Future.delayed(Duration(seconds: 2));
    state = state.copyWith(errorMessage: null);
  }

  void remove(ProductModel model) {
    final ids = state.selectedIds;
    state = state.copyWith(
      errorMessage: null,
      selectedIds: ids.where((element) => element != model).toList(),
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

final selectAndSearchProductControllerProvider =
    NotifierProvider<SelectAndSearchProductController, ProductSelectionState>(
      () {
        return SelectAndSearchProductController();
      },
    );
