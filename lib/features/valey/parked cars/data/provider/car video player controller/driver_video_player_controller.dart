import 'dart:developer';

import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/features/valey/parked%20cars/data/provider/car%20video%20player%20controller/driver_video_controller_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class DriverVideoPlayerController
    extends StateNotifier<DriverVideoPlayerState> {
  final List<Map<String, dynamic>> videos;

  DriverVideoPlayerController(this.videos)
      : super(DriverVideoPlayerState(
          currentIndex: -1,
          isPlaying: false,
          controller: null,
        ));
  Future<void> playVideoAt(int index) async {
    if (index < 0 || index >= videos.length) return;

    // Dispose previous controller
    if (state.controller != null) {
      await state.controller!.pause();
      await state.controller!.dispose();
    }

    final filePath = videos[index]["file"];
    if (filePath == null || filePath.isEmpty) return;

    final url = "${ApiConstants.mediaBaseUrl}$filePath";
    log("Playing video: $url");

    final uri = Uri.tryParse(url);
    if (uri == null || !(uri.isScheme("http") || uri.isScheme("https"))) {
      log("Invalid video URL: $url");
      return;
    }

    final controller = VideoPlayerController.networkUrl(uri);

    try {
      await controller.initialize();
      await controller.play();

      state = DriverVideoPlayerState(
        currentIndex: index,
        isPlaying: true,
        controller: controller,
      );
    } catch (e, st) {
      log("Video init failed: $e");
      log("$st");
    }
  }

  Future<void> togglePlayPause() async {
    if (state.controller == null) return;

    if (state.isPlaying) {
      await state.controller!.pause();
    } else {
      await state.controller!.play();
    }

    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  Future<void> previosVideo() async {}
  Future<void> nextVideo() async {}

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

final driverVideoPlayerProvider = StateNotifierProvider.autoDispose<
    DriverVideoPlayerController, DriverVideoPlayerState>((ref) {
  throw UnimplementedError("Must override with video list in the screen");
});
