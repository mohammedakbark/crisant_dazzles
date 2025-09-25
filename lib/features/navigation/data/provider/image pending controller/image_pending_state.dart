import 'package:dazzles/features/navigation/data/model/image_pending_product_model.dart';

class ImagePendingState {
  final List<ImagePendingProductsModel> products;
  final bool isLoadingMore;

  ImagePendingState({required this.products, this.isLoadingMore = false});

  ImagePendingState copyWith({
    List<ImagePendingProductsModel>? products,
    bool? isLoadingMore,
  }) {
    return ImagePendingState(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
