import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/camera%20and%20upload/data/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoColorSelectionTile extends ConsumerWidget {
  const LogoColorSelectionTile({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacer(
          hp: .01,
        ),
        Text(
          "Logo Color",
          style: AppStyle.boldStyle(
              color: AppColors.kTextPrimaryColor, fontSize: 12),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Checkbox.adaptive(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(AppColors.kTeal),
                    value: ref.watch(logoColorSelctionControllerProvider) ==
                        "default",
                    onChanged: (value) {
                      ref
                          .watch(logoColorSelctionControllerProvider.notifier)
                          .state = "default";
                    },
                  ),
                  Text(
                    "Default",
                    style: AppStyle.boldStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  Checkbox.adaptive(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(AppColors.kTeal),
                    value: ref.watch(logoColorSelctionControllerProvider) ==
                        "white",
                    onChanged: (value) {
                      ref
                          .watch(logoColorSelctionControllerProvider.notifier)
                          .state = "white";
                    },
                  ),
                  Text(
                    "White",
                    style: AppStyle.boldStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  Checkbox.adaptive(
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(AppColors.kTeal),
                    value: ref.watch(logoColorSelctionControllerProvider) ==
                        "black",
                    onChanged: (value) {
                      ref
                          .watch(logoColorSelctionControllerProvider.notifier)
                          .state = "black";
                    },
                  ),
                  Text(
                    "Black",
                    style: AppStyle.boldStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
