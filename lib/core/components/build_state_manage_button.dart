import 'package:dazzles/core/components/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildStateManageComponent extends StatelessWidget {
  final AsyncValue<Object?> stateController;
  final Widget Function(Object? data) successWidget;
  final Widget Function(Object, StackTrace)? errorWidget;
  final Widget Function()? loadingWidget;
  const BuildStateManageComponent({
    super.key,
    required this.stateController,
    this.errorWidget,
    required this.successWidget,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return stateController.when(
      data: successWidget,
      error:
          errorWidget ??
          (error, tr) {
            return successWidget('');
          },
      loading: loadingWidget ?? () => AppLoading(),
    );
  }
}
