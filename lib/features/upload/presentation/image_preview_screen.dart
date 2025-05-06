import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;

  PreviewScreen({super.key, required this.imagePath});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  File? files;

  void _onUpload(BuildContext context) async {
    files = await stackImageWithLogo(
      baseImageFile: File(widget.imagePath),
      logoAssetPath: "assets/images/log.png",
    );
    final bytes = await files!.readAsBytes();
    final String base64 = base64Encode(bytes);
    // log(base64);
    setState(() {});
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text("Uploading...")));
  }

  void _onDiscard(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.imagePath);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text("Preview Image", style: AppStyle.boldStyle()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                duration: Duration(milliseconds: 600),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                      height: size.height * 0.5,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              files != null ? Image.file(files!) : SizedBox(),
              const SizedBox(height: 40),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomIn(
                    duration: Duration(milliseconds: 700),
                    child: ElevatedButton.icon(
                      onPressed: () => _onUpload(context),
                      icon: Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.kWhite,
                      ),
                      label: Text("Upload"),
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
                  const SizedBox(width: 20),
                  ZoomIn(
                    duration: Duration(milliseconds: 900),
                    child: ElevatedButton.icon(
                      onPressed: () => _onDiscard(context),
                      icon: Icon(Icons.delete_outline, color: AppColors.kWhite),
                      label: Text("Discard"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kErrorPrimary,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
    double logoWidth = imageSize.width * 0.2;
    double logoHeight = logoWidth * (logoImage.height / logoImage.width);

    final logoRect = Rect.fromLTWH(
      imageSize.width - logoWidth - 20, // Right margin
      20, // Top margin
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
    final file = File('${dir.path}/stacked_image.png');
    await file.writeAsBytes(pngBytes);

    return file;
  }
}
