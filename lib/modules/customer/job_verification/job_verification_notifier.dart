import 'dart:io';

import 'package:community_app/modules/customer/job_verification/job_verification_screen.dart';
import 'package:community_app/res/images.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class JobVerificationNotifier extends ChangeNotifier {
  late VideoPlayerController videoController;
  bool isMuted = false;
  bool isFullscreen = false;

  // Add image lists for before and after photos
  List<ImagePair> imagePairs = [
    ImagePair(
      before: "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
      after: "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
    ),
    ImagePair(
      before: "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
      after: "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
    ),
    ImagePair(
      before: AppImages.videoPlayer,
      after: AppImages.videoPlayer,
      isVideo: true,
    ),
    ImagePair(
      before: "https://jureursicphotography.com/wp-content/uploads/2020/10/2020_02_21_Sephora-Favurite-Box5247.jpg",
      after: "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
    ),
  ];

  JobVerificationNotifier() {
    initializeVideo();

    notifyListeners();
  }

  void initializeVideo() {
    videoController = VideoPlayerController.asset('assets/video/sample_video.mp4')
      ..initialize().then((_) {
        notifyListeners();
      });
    videoController.addListener(notifyListeners);
  }

  void toggleVideoPlayback() {
    if (videoController.value.isPlaying) {
      videoController.pause();
    } else {
      videoController.play();
    }
    notifyListeners();
  }

  void toggleMute() {
    isMuted = !isMuted;
    videoController.setVolume(isMuted ? 0 : 1);
    notifyListeners();
  }

  void seekTo(Duration position) {
    videoController.seekTo(position);
  }

  void toggleFullscreen(BuildContext context) {
    isFullscreen = !isFullscreen;
    notifyListeners();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: videoController.value.aspectRatio,
                  child: VideoPlayer(videoController),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    isFullscreen = false;
                    notifyListeners();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // Methods to add images to the before and after lists
  // void addBeforeImage(File image) {
  //   beforeImages.add(image);
  //   notifyListeners();
  // }


  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }
}
