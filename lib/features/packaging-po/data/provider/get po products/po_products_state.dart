import 'package:dazzles/features/packaging-po/data/model/po_product_model.dart';

class PoProductsSuccessState {
  final List<PoProductModel> poProducts;
  final List<int> selectedIds;
  final bool isLoadingMore;
  final bool isSelectionEnabled;

  PoProductsSuccessState(
      {required this.poProducts,
      this.isSelectionEnabled=false,
      this.isLoadingMore = false,
      this.selectedIds = const []});

  PoProductsSuccessState copyWith({
    List<int>? selectedIds,
    List<PoProductModel>? poProducts,
    bool? isLoadingMore,
    bool ?isSelectionEnabled
  }) {
    return PoProductsSuccessState(
      isSelectionEnabled:isSelectionEnabled??this.isSelectionEnabled,
      selectedIds: selectedIds ?? this.selectedIds,
      poProducts: poProducts ?? this.poProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
