import 'package:video_player/video_player.dart';

class DriverVideoPlayerState {
  final int currentIndex;
  final bool isPlaying;
  final VideoPlayerController? controller;

  DriverVideoPlayerState({
    required this.currentIndex,
    required this.isPlaying,
    required this.controller,
  });

  DriverVideoPlayerState copyWith({
    int? currentIndex,
    bool? isPlaying,
    VideoPlayerController? controller,
  }) {
    return DriverVideoPlayerState(
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      controller: controller ?? this.controller,
    );
  }
}
