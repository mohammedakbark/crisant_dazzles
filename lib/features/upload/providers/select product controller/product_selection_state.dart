import 'package:dazzles/features/product/data/models/product_model.dart';

class ProductSelectionState {
  final List<ProductModel> selectedIds;
  final ProductModel? productModel;
  final String? errorMessage;
  final bool enableAddButton;

  ProductSelectionState({
    required this.selectedIds,
    required this.productModel,
    required this.errorMessage,
    required this.enableAddButton,
  });
  ProductSelectionState copyWith({
    List<ProductModel>? selectedIds,
    ProductModel? productModel,
    String? errorMessage,
    bool? enableAddButton,
  }) => ProductSelectionState(
    enableAddButton: enableAddButton ?? this.enableAddButton,
    errorMessage: errorMessage,
    productModel: productModel,
    selectedIds: selectedIds ?? this.selectedIds,
  );
}
