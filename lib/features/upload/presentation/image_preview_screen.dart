import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/components/shimmer_effect.dart';
import 'package:dazzles/core/constant/app_images.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/home/data/providers/dashboard_controller.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/data/providers/get%20pending%20products/get_pending_products_controller.dart';
import 'package:dazzles/features/upload/data/providers/select%20&%20search%20product/product_id_selection_controller.dart';
import 'package:dazzles/features/upload/data/providers/upload_image_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class PreviewScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final ProductModel productModel;

  const PreviewScreen({
    super.key,
    required this.imagePath,
    required this.productModel,
  });

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  File? files;
  @override
  void initState() {
    super.initState();

    convert();
  }

  void convert() async {
    files = null;
    files = await stackImageWithLogo(
      baseImageFile: File(widget.imagePath),
      logoAssetPath: AppImages.logoPng,
    );
    Future.microtask(() {
      ref.invalidate(selectAndSearchProductControllerProvider);
      ref
          .read(selectAndSearchProductControllerProvider.notifier)
          .add(widget.productModel, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Update image", style: AppStyle.boldStyle()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: AppMargin(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppSpacer(hp: .01),
              _buildImageView(),
              AppSpacer(hp: .05),
              _buidButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onUpload(BuildContext context, UploadImageNotifier controller) async {
    final state = ref.read(selectAndSearchProductControllerProvider);

    List<int> ids = [];
    for (var i in state.selectedIds) {
      ids.add(i.id);
    }
    if (files != null) {
      await controller.uploadImage(
        context: context,
        productIds: ids,
        file: files!,
      );
      ref.invalidate(getAllPendingProductControllerProvider);
      ref.invalidate(dashboardControllerProvider);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  Future<File> stackImageWithLogo({
    required File baseImageFile,
    required String logoAssetPath,
  }) async {
    // Load base image
    final baseImageBytes = await baseImageFile.readAsBytes();
    final baseImage = await decodeImageFromList(baseImageBytes);

    // Load logo
    final logoData = await rootBundle.load(logoAssetPath);
    final logoImage = await decodeImageFromList(logoData.buffer.asUint8List());

    // Draw on canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final imageSize = Size(
      baseImage.width.toDouble(),
      baseImage.height.toDouble(),
    );

    canvas.drawImage(baseImage, Offset.zero, paint);

    // Resize logo
    double logoWidth = imageSize.width * 0.3;
    double logoHeight = logoWidth * (logoImage.height / logoImage.width);

    final logoRect = Rect.fromLTWH(
      50,
      imageSize.height - logoHeight - 50,
      logoWidth,
      logoHeight,
    );

    canvas.drawImageRect(
      logoImage,
      Rect.fromLTWH(
        0,
        0,
        logoImage.width.toDouble(),
        logoImage.height.toDouble(),
      ),
      logoRect,
      paint,
    );

    final composedImage = await recorder.endRecording().toImage(
      baseImage.width,
      baseImage.height,
    );

    // Get PNG bytes from ui.Image
    final byteData = await composedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final pngBytes = byteData!.buffer.asUint8List();

    // Decode to image package format
    final img.Image imagePkg = img.decodeImage(pngBytes)!;

    // Resize for compression (optional)
    final resized = img.copyResize(
      imagePkg,
      width: (imagePkg.width * 0.7).toInt(), // resize to 70% of original
    );

    // Encode to JPG (smaller size, you can use PNG if needed)
    final jpgBytes = img.encodeJpg(resized, quality: 85);

    // Save file
    final dir = await getTemporaryDirectory();
    final fileName =
        'stacked_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(jpgBytes);

    return file;
  }
  // ISOLATION USING
  // Future<File> stackImageWithLogo({
  //   required File baseImageFile,
  //   required String logoAssetPath,
  // }) async {
  //   // Step 1: Load base image (from file)
  //   final baseImageBytes = await baseImageFile.readAsBytes();
  //   final baseImage = await decodeImageFromList(baseImageBytes);

  //   // Step 2: Load logo image (from assets)
  //   final logoData = await rootBundle.load(logoAssetPath);
  //   final logoImage = await decodeImageFromList(logoData.buffer.asUint8List());

  //   // Step 3: Draw base image + logo on canvas
  //   final recorder = ui.PictureRecorder();
  //   final canvas = Canvas(recorder);
  //   final paint = Paint();

  //   final imageSize = Size(
  //     baseImage.width.toDouble(),
  //     baseImage.height.toDouble(),
  //   );

  //   canvas.drawImage(baseImage, Offset.zero, paint);

  //   double logoWidth = imageSize.width * 0.3;
  //   double logoHeight = logoWidth * (logoImage.height / logoImage.width);

  //   final logoRect = Rect.fromLTWH(
  //     50,
  //     imageSize.height - logoHeight - 50,
  //     logoWidth,
  //     logoHeight,
  //   );

  //   canvas.drawImageRect(
  //     logoImage,
  //     Rect.fromLTWH(
  //       0,
  //       0,
  //       logoImage.width.toDouble(),
  //       logoImage.height.toDouble(),
  //     ),
  //     logoRect,
  //     paint,
  //   );

  //   final composedImage = await recorder.endRecording().toImage(
  //     baseImage.width,
  //     baseImage.height,
  //   );

  //   final byteData = await composedImage.toByteData(
  //     format: ui.ImageByteFormat.png,
  //   );
  //   final pngBytes = byteData!.buffer.asUint8List();

  //   // Step 4: Process/compress in background using compute()
  //   final compressedBytes = await compute(_compressImageInBackground, pngBytes);

  //   // Step 5: Save compressed image to temporary file
  //   final dir = await getTemporaryDirectory();
  //   final fileName =
  //       'stacked_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   final file = File('${dir.path}/$fileName');
  //   await file.writeAsBytes(compressedBytes);

  //   return file;
  // }

  // /// This function runs in a background isolate using `compute()`
  // Uint8List _compressImageInBackground(Uint8List pngBytes) {
  //   final image = img.decodeImage(pngBytes)!;

  //   // Resize to 70% of original
  //   final resized = img.copyResize(image, width: (image.width * 0.7).toInt());

  //   // Encode to JPG (quality 85)
  //   return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
  // }

  Widget _buildImageView() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FadeInDown(
        duration: Duration(milliseconds: 600),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: ResponsiveHelper.wp,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.kBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child:
                    files != null
                        ? Hero(
                          tag: files!.path,
                          child: Image.file(
                            height: ResponsiveHelper.hp * .3,
                            files!,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                        : ShimmerEffect(
                          child: ShimmerEffect.placeHolder(
                            radius: 18,
                            height: ResponsiveHelper.hp * .3,
                            width: ResponsiveHelper.wp,
                          ),
                        ),
              ),
            ),
            Positioned(
              right: 5,
              child: IconButton(
                onPressed: () {
                  if (files != null) {
                    context.push(
                      openImage,
                      extra: {"heroTag": files?.path, "path": files as File},
                    );
                  }
                },
                icon: Icon(Icons.remove_red_eye, color: AppColors.kWhite),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  _buidButton() {
    final uploadImageState = ref.watch(uploadImageControllerProvider);
    final uploadImageController = ref.read(
      uploadImageControllerProvider.notifier,
    );
    final productSelectionState = ref.watch(
      selectAndSearchProductControllerProvider,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ZoomIn(
          duration: Duration(milliseconds: 700),
          child: ElevatedButton.icon(
            onPressed: () {
              if (files != null) {
                context.push(copySameImageScreen, extra: files as File);
              }
            },
            icon: Icon(
              Icons.copy,
              color:
                  files != null
                      ? AppColors.kWhite
                      : AppColors.kTextPrimaryColor,
            ),
            label: Text(
              "Copy same",
              style: AppStyle.normalStyle(
                color:
                    files != null
                        ? AppColors.kWhite
                        : AppColors.kTextPrimaryColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kTeal,
              foregroundColor: AppColors.kWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        ZoomIn(
          duration: Duration(milliseconds: 700),
          child: BuildStateManageComponent(
            stateController: uploadImageState,

            successWidget:
                (data) => ElevatedButton.icon(
                  onPressed:
                      files != null &&
                              productSelectionState.selectedIds.isNotEmpty
                          ? () => _onUpload(context, uploadImageController)
                          : null,
                  icon: Icon(
                    Icons.cloud_upload_outlined,
                    color:
                        files != null
                            ? AppColors.kWhite
                            : AppColors.kTextPrimaryColor,
                  ),
                  label: Text(
                    "Upload",
                    style: AppStyle.normalStyle(
                      color:
                          files != null
                              ? AppColors.kWhite
                              : AppColors.kTextPrimaryColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kGreen,
                    foregroundColor: AppColors.kWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}

 // PNG WIH MAXIMUM QUALITY

// Future<File> stackImageWithLogo({
  //   required File baseImageFile,
  //   required String logoAssetPath,
  // }) async {
  //   final baseImageBytes = await baseImageFile.readAsBytes();
  //   final baseImage = await decodeImageFromList(baseImageBytes);

  //   final logoData = await rootBundle.load(logoAssetPath);
  //   final logoImage = await decodeImageFromList(logoData.buffer.asUint8List());

  //   final recorder = ui.PictureRecorder();
  //   final canvas = Canvas(recorder);
  //   final paint = Paint();

  //   final imageSize = Size(
  //     baseImage.width.toDouble(),
  //     baseImage.height.toDouble(),
  //   );

  //   canvas.drawImage(baseImage, Offset.zero, paint);

  //   // Resize logo relative to the base image size
  //   double logoWidth = imageSize.width * 0.3;
  //   double logoHeight = logoWidth * (logoImage.height / logoImage.width);

  //   // ➤ Position: bottom-left
  //   final logoRect = Rect.fromLTWH(
  //     50, // left padding
  //     imageSize.height - logoHeight - 50, // bottom padding
  //     logoWidth,
  //     logoHeight,
  //   );

  //   canvas.drawImageRect(
  //     logoImage,
  //     Rect.fromLTWH(
  //       0,
  //       0,
  //       logoImage.width.toDouble(),
  //       logoImage.height.toDouble(),
  //     ),
  //     logoRect,
  //     paint,
  //   );

  //   final finalImage = await recorder.endRecording().toImage(
  //     baseImage.width,
  //     baseImage.height,
  //   );

  //   final byteData = await finalImage.toByteData(
  //     format: ui.ImageByteFormat.png,
  //   );
  //   final pngBytes = byteData!.buffer.asUint8List();

  //   final dir = await getTemporaryDirectory();
  //   final fileName =
  //       'stacked_image_${DateTime.now().millisecondsSinceEpoch}.png';

  //   final file = File('${dir.path}/$fileName');
  //   await file.writeAsBytes(pngBytes);

  //   return file;
  // }





