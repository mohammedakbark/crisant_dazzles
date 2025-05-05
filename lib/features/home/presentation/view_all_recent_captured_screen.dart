import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_network_image.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/home/data/models/recently_captured.dart';
import 'package:dazzles/features/home/providers/recently_captured_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewAllRecentCapturedScreen extends ConsumerStatefulWidget {
  const ViewAllRecentCapturedScreen({super.key});

  @override
  ConsumerState<ViewAllRecentCapturedScreen> createState() =>
      _ViewAllRecentCapturedScreenState();
}

class _ViewAllRecentCapturedScreenState
    extends ConsumerState<ViewAllRecentCapturedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(recntlyCapturedControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recentCapturedController = ref.watch(
      recntlyCapturedControllerProvider,
    );
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Recently Captured", style: AppStyle.boldStyle()),
      ),
      body: AppMargin(
        child: RefreshIndicator(
          onRefresh: () async {
            return ref.refresh(recntlyCapturedControllerProvider);
          },
          child: BuildStateManageComponent(
            controller: recentCapturedController,
            errorWidget:
                (p0, p1) => AppErrorView(
                  error: p0.toString(),
                  onRetry: () {
                    return ref.refresh(recntlyCapturedControllerProvider);
                  },
                ),
            successWidget: (p0) {
              final data = p0 as List<RecentCapturedModel>;
              return data.isEmpty
                  ? AppErrorView(error: "Nothing is captured recently")
                  : GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder:
                        (context, index) => Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: AppColors.kBgColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: AppColors.kPrimaryColor.withAlpha(30),
                              ),
                            ],
                            // border: Border.all(color: AppColors.kPrimaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AppNetworkImage(
                                  fit: BoxFit.cover,
                                  imageFile:
                                      ApiConstants.imageBaseUrl +
                                      data[index].productPicture,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data[index].productName,
                                  style: AppStyle.normalStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                  );
            },
          ),
        ),
      ),
    );
  }
}
