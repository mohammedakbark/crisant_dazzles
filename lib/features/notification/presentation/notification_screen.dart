
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_error_componet.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/local/hive/controllers/upload_manager.dart';
import 'package:dazzles/core/local/hive/models/upload_photo_adapter.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/features/upload/data/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(uploadManagerProvider);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final uploadManagerState = ref.watch(uploadManagerProvider);
    final uploadManagerProviderController =
        ref.read(uploadManagerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Upload Failed", style: AppStyle.boldStyle()),
        actions: [
          uploadManagerState.value != null &&
                  uploadManagerState.value!.isNotEmpty
              ? TextButton(
                  onPressed: () async {
                    await uploadManagerProviderController.clearAll();
                  },
                  child: Text("Clear All"))
              : SizedBox()
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          return ref.refresh(uploadManagerProvider);
        },
        child: AppMargin(
            child: BuildStateManageComponent(
          stateController: uploadManagerState,
          
          successWidget: (data) {
            final uploads = data as List<UploadPhotoModel>;
            return uploads.isEmpty
                ? AppErrorView(
                    error: "No data found!",
                  )
                : ListView.separated(
                    padding: EdgeInsets.only(top: 20),
                    itemBuilder: (context, index) {
                      return _buildNotificationTile(uploads[index]);
                    },
                    separatorBuilder: (context, index) => AppSpacer(hp: .03),
                    itemCount: uploads.length,
                  );
          },
        )),
      ),
    );
  }

  Widget _buildNotificationTile(UploadPhotoModel model) {
    final status = model.isUploadSuccess;
    final title = status ? "Photo uploaded successfully" : model.failedReason;
    final date = IntlC.convertToDate(model.dateTime ?? DateTime(2000));
    final time = IntlC.convertToTime(model.dateTime ?? DateTime(2000));

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor:
                  status ? AppColors.kPrimaryColor : AppColors.kErrorPrimary,
              child: Icon(
                status ? Icons.check_circle_outline : Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            // CircularProgressIndicator(),
            AppSpacer(
              wp: .03,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload Failed!",
                    style: AppStyle.boldStyle(
                        fontSize: 16, color: AppColors.kBgColor),
                  ),
                  Text(
                    title,
                    style: AppStyle.boldStyle(
                        fontSize: 12, color: AppColors.kFillColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: AppColors.kTextPrimaryColor),
                        SizedBox(width: 4),
                        Text(
                          date,
                          style: AppStyle.normalStyle(
                              color: AppColors.kTextPrimaryColor),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.access_time,
                            size: 14, color: AppColors.kTextPrimaryColor),
                        SizedBox(width: 4),
                        Text(
                          time,
                          style: AppStyle.normalStyle(
                              color: AppColors.kTextPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacer(
              wp: .03,
            ),
            InkWell(
              onTap: () async {
                if (model.isUploading != true) {
                  ref
                      .read(uploadImageControllerProvider.notifier)
                      .uploadFailedImageAgain({
                    "ids": model.ids,
                    "id": model.id,
                    "path": model.imagePath,
                    "ref": ref
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: model.isUploading == true
                      ? AppColors.kFillColor
                      : AppColors.kDeepPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  model.isUploading == true ? "Uplaoding" : "Upload",
                  style: AppStyle.normalStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ));
  }
}
