import 'package:dazzles/core/components/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildStateManageComponent extends StatelessWidget {
  final AsyncValue<Object?> controller;
  final Widget Function(Object?) successWidget;
  final Widget Function(Object, StackTrace)? errorWidget;
  final Widget Function()? loadingWidget;
  const BuildStateManageComponent({
    super.key,
    required this.controller,
    this.errorWidget,
    required this.successWidget,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return controller.when(
      data:
      
       successWidget,
      error:
          errorWidget ??
          (error, tr) {
            return successWidget('');
          },
      loading: loadingWidget ?? () => AppLoading(),
    );
  }
}
