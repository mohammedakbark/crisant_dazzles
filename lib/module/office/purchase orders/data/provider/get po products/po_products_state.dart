import 'package:dazzles/module/office/purchase%20orders/data/model/po_product_model.dart';

class PoProductsSuccessState {
  final List<PoProductModel> poProducts;
  final List<int> selectedIds;
  final bool isLoadingMore;

  PoProductsSuccessState(
      {required this.poProducts,
      this.isLoadingMore = false,
      this.selectedIds = const []});

  PoProductsSuccessState copyWith({
    List<int> ?selectedIds,
    List<PoProductModel>? poProducts,
    bool? isLoadingMore,
  }) {
    return PoProductsSuccessState(
      selectedIds:selectedIds??this.selectedIds,
      poProducts: poProducts ?? this.poProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
