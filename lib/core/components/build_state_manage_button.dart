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
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: stateController.when(
         
        data: successWidget,
        error:
            errorWidget ??
            (error, tr) {
              return successWidget('');
            },
        loading: loadingWidget ?? () => AppLoading(),
      ),
    );
  }
}
