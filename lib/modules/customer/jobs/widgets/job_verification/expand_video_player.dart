import 'dart:io';

import 'package:Xception/modules/customer/jobs/widgets/job_verification/job_verification_notifier.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ExpandedMediaViewer extends StatelessWidget {
  final bool isVideo;

  const ExpandedMediaViewer({super.key, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JobVerificationNotifier("", 2),
      child: Consumer<JobVerificationNotifier>(
        builder: (context, jobVerificationNotifier, child) {
          return buildBody(context, jobVerificationNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, JobVerificationNotifier notifier) {
    final controller = notifier.videoController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: isVideo
                  ? (controller == null
                  ? const LottieLoader()
                  : controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
                  : const LottieLoader())
                  : Image.asset(
                AppImages.loginImage, // Replace with dynamic image path if needed
                fit: BoxFit.contain,
              ),
            ),

            if (isVideo && controller != null && controller.value.isInitialized)
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Slider(
                      value: controller.value.position.inSeconds.toDouble(),
                      max: controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        notifier.seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(controller.value.position), style: const TextStyle(color: Colors.white)),
                        Text(_formatDuration(controller.value.duration), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                          onPressed: notifier.toggleVideoPlayback,
                        ),
                        IconButton(
                          icon: Icon(notifier.isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
                          onPressed: notifier.toggleMute,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}


class CompareImagesScreen extends StatelessWidget {
  final File beforeImageFile;
  final File afterImageFile;

  const CompareImagesScreen({
    super.key,
    required this.beforeImageFile,
    required this.afterImageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Images')),
      body: Column(
        children: [
          Expanded(
            child: PhotoView(
              imageProvider: FileImage(beforeImageFile),
              backgroundDecoration: BoxDecoration(color: Colors.black),
              heroAttributes: const PhotoViewHeroAttributes(tag: 'beforeImage'),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            child: PhotoView(
              imageProvider: FileImage(afterImageFile),
              backgroundDecoration: BoxDecoration(color: Colors.black),
              heroAttributes: const PhotoViewHeroAttributes(tag: 'afterImage'),
            ),
          ),
        ],
      ),
    );
  }
}
