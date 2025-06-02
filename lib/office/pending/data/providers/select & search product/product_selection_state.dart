import 'package:dazzles/office/product/data/models/product_model.dart';

class ProductSelectionState {
  final List<ProductModel> selectedIds;
  final ProductModel? productModel;
  final String? errorMessage;
  final bool enableAddButton;
  final bool isLoading;

  ProductSelectionState({
    required this.selectedIds,
    required this.productModel,
    required this.errorMessage,
    required this.enableAddButton,
    required this.isLoading,
  });
  ProductSelectionState copyWith({
    List<ProductModel>? selectedIds,
    ProductModel? productModel,
    String? errorMessage,
    bool? enableAddButton,
    bool ?isLoading
  }) => ProductSelectionState(
    isLoading: isLoading??this.isLoading,
    enableAddButton: enableAddButton ?? this.enableAddButton,
    errorMessage: errorMessage,
    productModel: productModel,
    selectedIds: selectedIds ?? this.selectedIds,
  );
}
