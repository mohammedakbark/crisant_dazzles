import 'package:dazzles/features/product/data/models/product_model.dart';

class ProductSuccessState {
  final List<ProductModel> products;
  final bool isLoadingMore;

  ProductSuccessState({required this.products, this.isLoadingMore = false});

  ProductSuccessState copyWith({
    List<ProductModel>? products,
    bool? isLoadingMore,
  }) {
    return ProductSuccessState(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}