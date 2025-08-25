import 'package:dazzles/module/common/scan%20product/data/model/scanned_product_model.dart';

abstract class ScannedProductState {}

class ScannedProductInitial extends ScannedProductState {}

class ScannedProductLoading extends ScannedProductState {}

class ScannedProductLoaded extends ScannedProductState {
  final ScannedProductModel product;

  ScannedProductLoaded(this.product);
}

class ScannedProductError extends ScannedProductState {
  final String message;

  ScannedProductError(this.message);
}
