import 'package:dazzles/module/office/packaging/data/model/supplier_model.dart';

class SuppliersSuccessState {
  final List<SupplierModel> purchaseOrderList;
  final bool isLoadingMore;

  SuppliersSuccessState({required this.purchaseOrderList, this.isLoadingMore = false});

  SuppliersSuccessState copyWith({
    List<SupplierModel>? purchaseOrderList,
    bool? isLoadingMore,
  }) {
    return SuppliersSuccessState(
      purchaseOrderList: purchaseOrderList ?? this.purchaseOrderList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
