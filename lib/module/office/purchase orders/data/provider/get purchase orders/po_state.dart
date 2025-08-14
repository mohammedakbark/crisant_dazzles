import 'package:dazzles/module/office/purchase%20orders/data/model/po_model.dart';

class POSuccessState {
  final List<PoModel> purchaseOrderList;
  final bool isLoadingMore;

  POSuccessState({required this.purchaseOrderList, this.isLoadingMore = false});

  POSuccessState copyWith({
    List<PoModel>? purchaseOrderList,
    bool? isLoadingMore,
  }) {
    return POSuccessState(
      purchaseOrderList: purchaseOrderList ?? this.purchaseOrderList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
