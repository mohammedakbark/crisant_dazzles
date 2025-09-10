import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/car%20video%20player%20controller/driver_video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:video_player/video_player.dart';

class DriverVideoPlayerScreen extends ConsumerWidget {
  final List<Map<String, dynamic>> videos;
  const DriverVideoPlayerScreen({super.key, required this.videos});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        driverVideoPlayerProvider.overrideWith(
          (ref) => DriverVideoPlayerController(videos),
        ),
      ],
      child: const _DriverVideoPlayerView(),
    );
  }
}

class _DriverVideoPlayerView extends ConsumerWidget {
  const _DriverVideoPlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driverVideoPlayerProvider);
    final controller = state.controller;
    final videos = ref.read(driverVideoPlayerProvider.notifier).videos;

    return Scaffold(
      backgroundColor: Colors.black,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Video Player",
            style: AppStyle.boldStyle().copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
            child: Center(
              child: controller != null && controller.value.isInitialized
                  ? Hero(
                      tag: 'video_player',
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadiusGeometry.all(Radius.circular(20)),
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: Stack(
                              children: [
                                VideoPlayer(controller),
                                // Video Controls Overlay
                                _buildVideoControls(context, ref, controller),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : _buildEmptyState(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildVideoPlaylist(context, ref, videos, state),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.kFillColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.kTeal.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.kTeal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              SolarIconsOutline.videoLibrary,
              size: 48,
              color: AppColors.kTeal,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Select a video to play",
            style: AppStyle.boldStyle().copyWith(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Choose from the playlist below",
            style: AppStyle.boldStyle().copyWith(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoControls(
      BuildContext context, WidgetRef ref, VideoPlayerController controller) {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Progress Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: AppColors.kTeal,
                    bufferedColor: AppColors.kTeal.withAlpha(50),
                    backgroundColor: Colors.white.withAlpha(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    onPressed: () {
                      ref
                          .read(driverVideoPlayerProvider.notifier)
                          .togglePlayPause();
                    },
                    isMain: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isMain = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
        border: Border.all(
          color: isMain ? AppColors.kTeal : Colors.white.withOpacity(0.3),
          width: isMain ? 2 : 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: isMain ? 32 : 24,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildVideoPlaylist(BuildContext context, WidgetRef ref,
      List<Map<String, dynamic>> videos, dynamic state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
          child: Row(
            children: [
              Icon(Icons.playlist_play, color: AppColors.kTeal, size: 24),
              const SizedBox(width: 12),
              Text(
                "Videos",
                style: AppStyle.boldStyle().copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.kTeal.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${videos.length} videos",
                  style: AppStyle.boldStyle().copyWith(
                    color: AppColors.kTeal,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Video List
        Container(
          height: 140,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final isSelected = state.currentIndex == index;
              final isPlaying = state.isPlaying && isSelected;

              return _buildVideoTile(
                  context, ref, videos[index], index, isSelected, isPlaying);
            },
          ),
        ),
        AppSpacer(
          hp: .03,
        )
      ],
    );
  }

  Widget _buildVideoTile(BuildContext context, WidgetRef ref,
      Map<String, dynamic> video, int index, bool isSelected, bool isPlaying) {
    return Padding(
      padding: EdgeInsetsGeometry.only(right: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        width: isSelected ? 200 : 160,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              HapticFeedback.lightImpact();
              if (isSelected) {
                ref.read(driverVideoPlayerProvider.notifier).togglePlayPause();
              } else {
                ref.read(driverVideoPlayerProvider.notifier).playVideoAt(index);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.kTeal,
                          AppColors.kTeal.withAlpha(140),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          AppColors.kFillColor,
                          AppColors.kFillColor.withAlpha(140),
                        ],
                      ),
              ),
              child: Stack(
                children: [
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video Title
                        Expanded(
                          child: Text(
                            video["title"],
                            style: AppStyle.boldStyle().copyWith(
                              color: Colors.white,
                              fontSize: isSelected ? 16 : 14,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Bottom Row
                        Row(
                          children: [
                            if (isSelected) ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isPlaying ? "Playing" : "Paused",
                                style: AppStyle.boldStyle().copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ] else ...[
                              Icon(
                                Icons.video_library_outlined,
                                color: Colors.white.withOpacity(0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Tap to play",
                                style: AppStyle.boldStyle().copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Selection Indicator
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: AppColors.kTeal,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
