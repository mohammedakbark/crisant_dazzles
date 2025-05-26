import 'package:dazzles/office/product/data/models/product_model.dart';

class PendingProductSuccessState {
  final List<ProductModel> products;
  final bool isLoadingMore;

  PendingProductSuccessState({required this.products, this.isLoadingMore = false});

  PendingProductSuccessState copyWith({
    List<ProductModel>? products,
    bool? isLoadingMore,
  }) {
    return PendingProductSuccessState(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
