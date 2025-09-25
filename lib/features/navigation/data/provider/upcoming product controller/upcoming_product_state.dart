import 'package:dazzles/features/navigation/data/model/upcoming_product_model.dart';

class UpcomingProductState {
  final List<UpcomingProductsModel> products;
  final bool isLoadingMore;

  UpcomingProductState({required this.products, this.isLoadingMore = false});

  UpcomingProductState copyWith({
    List<UpcomingProductsModel>? products,
    bool? isLoadingMore,
  }) {
    return UpcomingProductState(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
