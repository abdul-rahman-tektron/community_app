import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/customer/job/job_completion_details_response.dart';
import 'package:Xception/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class JobVerificationNotifier extends BaseChangeNotifier {
  VideoPlayerController? videoController;
  bool isMuted = false;
  bool isFullscreen = false;

  String? jobId;
  int? vendorId;
  String? notes;

  List<CompletionPhoto> fileData = [];

  JobVerificationNotifier(this.jobId, this.vendorId) {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await fetchJobCompletionDetails(jobId ?? "");
  }

  Future<void> fetchJobCompletionDetails(String jobId) async {
    try {
      final response = await CustomerJobsRepository.instance
          .apiJobCompletionDetails(jobId);
      if (response is JobCompletionDetailsResponse) {
        fileData = response.photos ?? [];
        notes = response.notes ?? "";

        // After fetching, check if we have any videos
        _initializeVideoControllerIfNeeded();
      } else {
        fileData = [];
      }
    } catch (e) {
      print("Error fetching customer ongoing jobs: $e");
      fileData = [];
    }
    notifyListeners();
  }

  Future<void> apiUpdateJobStatus(BuildContext context, int? statusId, {String? notes}) async {
    if (statusId == null) return;
    try {
      notifyListeners();
      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(
          jobId: int.parse(jobId ?? "0"),
          statusId: statusId,
            notes: notes ?? "",
            createdBy: userData?.name ?? "",
            vendorId: vendorId ?? 0
        ),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        if(statusId == AppStatus.rework.id) {
          ToastHelper.showSuccess(
            "Status updated to: ${AppStatus.fromId(statusId)?.name ?? ""}",
          );
          Navigator.pop(context);
        } else {
          Navigator.pushNamed(
            context,
            AppRoutes.payment,
            arguments: {"jobId": int.parse(jobId ?? "0"), "vendorId" : vendorId},
          );
        }
      }
    } catch (e) {
      ToastHelper.showError('Error updating status: $e');
    } finally {
      notifyListeners();
    }
  }

  void _initializeVideoControllerIfNeeded() {
    // Find the first video URL (before or after)
    String? videoUrl;

    for (var photo in fileData) {
      if (photo.isBeforeVideo == true &&
          photo.beforePhotoUrl != null &&
          photo.beforePhotoUrl!.isNotEmpty) {
        videoUrl = photo.beforePhotoUrl;
        break;
      }
      if (photo.isAfterVideo == true &&
          photo.afterPhotoUrl != null &&
          photo.afterPhotoUrl!.isNotEmpty) {
        videoUrl = photo.afterPhotoUrl;
        break;
      }
    }

    if (videoUrl != null) {
      // Dispose previous controller if any
      videoController?.dispose();

      // Here, you might need to load from URL or file
      // If videoUrl is base64 or local asset, adapt accordingly
      // For example, if it's a network URL:
      videoController = VideoPlayerController.network(videoUrl!)
        ..initialize().then((_) {
          notifyListeners();
        });
      videoController!.addListener(notifyListeners);
    } else {
      // No videos found, dispose controller if exists
      videoController?.dispose();
      videoController = null;
    }
  }

  void toggleVideoPlayback() {
    if (videoController == null) return;

    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
    notifyListeners();
  }

  void toggleMute() {
    if (videoController == null) return;

    isMuted = !isMuted;
    videoController!.setVolume(isMuted ? 0 : 1);
    notifyListeners();
  }

  void seekTo(Duration position) {
    if (videoController == null) return;

    videoController!.seekTo(position);
  }

  void toggleFullscreen(BuildContext context) {
    if (videoController == null) return;

    isFullscreen = !isFullscreen;
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,
                    child: VideoPlayer(videoController!),
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
      ),
    );
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }
}
