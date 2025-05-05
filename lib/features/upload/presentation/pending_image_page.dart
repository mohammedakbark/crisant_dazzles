import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/providers/get_pending_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingImagePage extends ConsumerStatefulWidget {
  const PendingImagePage({super.key});

  @override
  ConsumerState<PendingImagePage> createState() => _PendingImagePageState();
}

class _PendingImagePageState extends ConsumerState<PendingImagePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          ref.read(getAllPendingProductControllerProvider.notifier).hasMore) {
        ref.read(getAllPendingProductControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingImageController = ref.watch(
      getAllPendingProductControllerProvider,
    );

    return AppMargin(
      child: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(getAllPendingProductControllerProvider);
        },
        child: BuildStateManageComponent(
          controller: pendingImageController,
          errorWidget: (p0, p1) => AppErrorView(error: p0.toString()),
          successWidget: (data) {
            final pending = data as List<ProductModel>;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final product = pending[index];
                      return Column(
                        children: [
                          AppNetworkImage(
                            imageFile:
                                "${ApiConstants.imageBaseUrl}${product.productPicture ?? ''}",
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ref
                        .read(getAllPendingProductControllerProvider.notifier)
                        .isLoadingMore
                    ? AppLoading(isTextLoading: true)
                    : SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
