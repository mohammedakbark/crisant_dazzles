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
import 'package:dazzles/core/utils/debauncer.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/features/product/data/models/product_model.dart';
import 'package:dazzles/features/upload/providers/pending_product_controller/get_pending_products_controller.dart';
import 'package:dazzles/features/upload/providers/select%20product%20controller/product_id_selection_controller.dart';
import 'package:dazzles/features/upload/providers/upload_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solar_icons/solar_icons.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final ProductModel productModel;

  const PreviewScreen({super.key, required this.imagePath, required this.productModel});

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
    Future.microtask(() {
      ref.invalidate(productIdSelectionControllerProvider);
      ref.read(productIdSelectionControllerProvider.notifier).add(widget.productModel);
    });
    files = null;
    files = await stackImageWithLogo(
      baseImageFile: File(widget.imagePath),
      logoAssetPath: AppImages.logoPng,
    );
    setState(() {});
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
              AppSpacer(hp: .01),
              // AppSpacer(hp: .01),
              // Text(
              //   "Hint: This image will be uploaded to all selected products.",
              //   style: AppStyle.smallStyle(color: AppColors.kTextPrimaryColor),
              // ),
              // AppSpacer(hp: .01),
              // _buildSearchBox(),
              // AppSpacer(hp: .01),
              // _buildSelectedIds(),

              // AppSpacer(hp: .01),
              // _buildSimilarProducts(),
              AppSpacer(hp: .05),
              // Buttons
              _buidButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onUpload(BuildContext context, UploadImageNotifier controller) async {
    if (files != null) {
      await controller.uploadImage(
        context: context,
        productId: widget.productModel.id,
        file: files!,
      );
      ref.invalidate(getAllPendingProductControllerProvider);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  Future<File> stackImageWithLogo({
    required File baseImageFile,
    required String logoAssetPath,
  }) async {
    final baseImageBytes = await baseImageFile.readAsBytes();
    final baseImage = await decodeImageFromList(baseImageBytes);

    final logoData = await rootBundle.load(logoAssetPath);
    final logoImage = await decodeImageFromList(logoData.buffer.asUint8List());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final imageSize = Size(
      baseImage.width.toDouble(),
      baseImage.height.toDouble(),
    );

    canvas.drawImage(baseImage, Offset.zero, paint);

    // Resize logo relative to the base image size
    double logoWidth = imageSize.width * 0.3;
    double logoHeight = logoWidth * (logoImage.height / logoImage.width);

    // ➤ Position: bottom-left
    final logoRect = Rect.fromLTWH(
      50, // left padding
      imageSize.height - logoHeight - 50, // bottom padding
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

    final finalImage = await recorder.endRecording().toImage(
      baseImage.width,
      baseImage.height,
    );

    final byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final pngBytes = byteData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final fileName =
        'stacked_image_${DateTime.now().millisecondsSinceEpoch}.png';

    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(pngBytes);

    return file;
  }

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
                          tag: "imageHero",
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
                    context.push(viewImageScreen, extra: files as File);
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
      productIdSelectionControllerProvider,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ZoomIn(
          duration: Duration(milliseconds: 700),
          child: ElevatedButton.icon(
            onPressed: () {
              context.push(copySameImageScreen);
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
