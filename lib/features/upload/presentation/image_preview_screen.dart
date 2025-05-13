import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/home/data/providers/dashboard_controller.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/data/providers/get%20pending%20products/get_pending_products_controller.dart';
import 'package:dazzles/features/upload/data/providers/select%20&%20search%20product/product_id_selection_controller.dart';
import 'package:dazzles/features/upload/data/providers/upload_image_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

Future<Map<String, dynamic>?> resizeWithImagePackage(String path) async {
  final file = File(path);
  final image = img.decodeImage(file.readAsBytesSync());
  if (image == null) return null;
  final resizedImage = img.copyResize(image, width: 1024);

  final reImage = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
  return {
    "height": resizedImage.height,
    "width": resizedImage.width,
    "image": reImage,
  };
}

class PreviewScreen extends ConsumerStatefulWidget {
  final String image;
  final ProductModel productModel;

  const PreviewScreen({
    super.key,
    required this.image,
    required this.productModel,
  });

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  bool isCopySame = false;
  bool imageUploading = false;

  Uint8List? imageFile;

  @override
  void initState() {
    super.initState();
    convert();
    Future.microtask(() {
      ref.invalidate(selectAndSearchProductControllerProvider);
      ref
          .read(selectAndSearchProductControllerProvider.notifier)
          .add(widget.productModel, context);
    });
  }

  void convert() async {
    try {
      final map = await compute(resizeWithImagePackage, widget.image);

      if (map != null) {
        final image = map['image'];
        final width = map["width"];
        final height = map["height"];
        imageFile = await FlutterImageCompress.compressWithList(
          image,
          minWidth: width,
          minHeight: height,
          quality: 80, // adjust as needed
        );
      }
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  final _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Update image", style: AppStyle.boldStyle()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppSpacer(hp: .005),
          _buildImageView(),
          AppSpacer(hp: .02),
          // AppSpacer(hp: .05),
          _buidButton(),

          AppSpacer(hp: .02),
        ],
      ),
    );
  }

  void _onUpload(BuildContext context, File file) async {
    try {
      final uploadImageController = ref.read(
        uploadImageControllerProvider.notifier,
      );
      final state = ref.read(selectAndSearchProductControllerProvider);

      List<int> ids = [];
      for (var i in state.selectedIds) {
        ids.add(i.id);
      }
      // if (files != null) {
      await uploadImageController.uploadImage(
        context: context,
        productIds: ids,
        file: file,
      );
      ref.invalidate(getAllPendingProductControllerProvider);
      ref.invalidate(dashboardControllerProvider);
      if (context.mounted) {
        context.go(route);
      }
    } catch (e) {
      log("error => $e");
    }
    // }
  }

  Widget _buildImageView() => Expanded(
    child:
        imageFile == null
            ? AppLoading()
            : FadeInDown(
              duration: Duration(milliseconds: 600),

              child: Crop(
                controller: _cropController,
                image: imageFile!,
                fixCropRect: true,

                interactive: true,
                // maskColor: AppColors.kBgColor,
                baseColor: AppColors.kBgColor,
                aspectRatio: 9 / 16, // 1:1 square
                onCropped: (value) async {
                  try {
                    if (value is CropSuccess) {
                      final directory = await getTemporaryDirectory();
                      final path =
                          '${directory.path}/${DateTime.timestamp()}.jpg';
                      final file = File(path);
                      await file.writeAsBytes(value.croppedImage);
                      log(file.path.toString());
                      if (file.path.isNotEmpty) {
                        if (isCopySame) {
                          context.push(copySameImageScreen, extra: file);
                        } else {
                          _onUpload(context, file);
                        }
                      }
                    }
                  } catch (e) {
                    log("onCrop => $e");
                  } finally {
                    imageUploading = false;
                    setState(() {});
                  }
                },
              ),
            ),
  );

  _buidButton() {
    final uploadImageState = ref.watch(uploadImageControllerProvider);
    final productSelectionState = ref.watch(
      selectAndSearchProductControllerProvider,
    );
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
      child:
          imageUploading
              ? AppLoading()
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ZoomIn(
                    duration: Duration(milliseconds: 700),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        isCopySame = true;
                        _cropImage();
                      },
                      icon: Icon(Icons.copy, color: AppColors.kWhite),
                      label: Text(
                        "Copy same",
                        style: AppStyle.normalStyle(color: AppColors.kWhite),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kTeal,
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
                  ZoomIn(
                    duration: Duration(milliseconds: 700),
                    child: BuildStateManageComponent(
                      stateController: uploadImageState,

                      successWidget:
                          (data) => ElevatedButton.icon(
                            onPressed:
                                productSelectionState.selectedIds.isNotEmpty
                                    ? () {
                                      isCopySame = false;
                                      _cropImage();
                                    }
                                    : null,
                            icon: Icon(
                              Icons.cloud_upload_outlined,
                              color: AppColors.kWhite,
                            ),
                            label: Text(
                              "Upload",
                              style: AppStyle.normalStyle(
                                color: AppColors.kWhite,
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
              ),
    );
  }

  void _cropImage() {
    imageUploading = true;
    setState(() {});
    _cropController.crop();
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