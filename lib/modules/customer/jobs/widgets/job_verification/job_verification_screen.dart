import 'dart:convert';

import 'package:Xception/core/model/customer/job/job_completion_details_response.dart';
import 'package:Xception/modules/customer/jobs/widgets/job_verification/expand_video_player.dart';
import 'package:Xception/modules/customer/jobs/widgets/job_verification/job_verification_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/styles.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_drawer.dart';
import 'package:Xception/utils/widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class JobVerificationScreen extends StatelessWidget {
  final String? jobId;
  final int? vendorId;
  const JobVerificationScreen({super.key, this.jobId, this.vendorId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobVerificationNotifier(jobId, vendorId),
      child: Consumer<JobVerificationNotifier>(
        builder: (context, notifier, child) {
          return buildBody(context, notifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, JobVerificationNotifier notifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    showStatusNotesPopup(
                      context,
                      onSubmit: (notes) async {
                        await notifier.apiUpdateJobStatus(
                            context, AppStatus.rework.id, notes: notes);
                      },
                    );
                  },
                  text: "Rework",
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    notifier.apiUpdateJobStatus(context, AppStatus.jobVerifiedPaymentPending.id);
                  },
                  text: "Proceed",
                ),
              ),
            ],
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text("Before & After Images", style: Theme.of(context).textTheme.titleMedium),
            ),
            SizedBox(height: 12.h),
            _buildBeforeAfterPairs(context, notifier, notifier.fileData),
            10.verticalSpace,
            Divider(),
            10.verticalSpace,
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: AppStyles.commonDecoration,
              padding: EdgeInsets.all(15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Feedback:", style: AppFonts.text14.bold.style),
                  10.verticalSpace,
                  Text(
                    notifier.notes ?? "",
                    style: AppFonts.text14.regular.style,
                  ),
                ],
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildBeforeAfterPairs(BuildContext context, JobVerificationNotifier notifier, List<CompletionPhoto> pairs) {
    if (pairs.isEmpty) return Center(child: const Text("No image pairs available"));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pairs.length,
        separatorBuilder: (_, __) => SizedBox(height: 30.h),
        itemBuilder: (context, index) {
          final pair = pairs[index];
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Before image/video + label
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pair.isBeforeVideo ?? false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ExpandedMediaViewer(isVideo: true)),
                          );
                        }
                      },
                      child: _buildImageWithLabel(
                        label: "Before",
                        imageUrl: pair.beforePhotoUrl ?? "",
                        isVideo: pair.isBeforeVideo ?? false,
                        controller: notifier.videoController,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Icon(LucideIcons.arrowRight300, size: 28.sp),
                  10.horizontalSpace,
                  // After image + label
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (pair.isAfterVideo ?? false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ExpandedMediaViewer(isVideo: true)),
                          );
                        }
                      },
                      child: _buildImageWithLabel(
                        label: "After",
                        imageUrl: pair.afterPhotoUrl ?? "",
                        isVideo: pair.isBeforeVideo ?? false,
                        controller: notifier.videoController,
                      ),
                    ),
                  ),
                ],
              ),
              if (!((pair.isBeforeVideo ?? false) || (pair.isAfterVideo ?? false))) ...[
                15.verticalSpace,
                // Compare button
                CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompareImagesScreen(beforeUrl: pair.beforePhotoUrl ?? "", afterUrl: pair.afterPhotoUrl ?? ""),
                      ),
                    );
                  },
                  icon: LucideIcons.arrowRightLeft300,
                  iconColor: AppColors.textPrimary,
                  iconOnLeft: true,
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.primary,
                  textStyle: AppFonts.text14.regular.style,
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  text: "Compare",
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageWithLabel({
    required String label,
    required String imageUrl,
    bool isVideo = false,
    VideoPlayerController? controller,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade500, width: 1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isVideo && controller != null && controller.value.isInitialized
                    ? SizedBox(height: 100.h, width: 100.w, child: VideoPlayer(controller))
                    : !isVideo
                    ? Image.memory(
                        base64Decode(imageUrl),
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                        },
                      )
                    : Container(
                        height: 100.h,
                        width: 100.w,
                        color: Colors.black12,
                        child: const Center(child: LottieLoader()),
                      ),
              ),
            ),
            if (isVideo) const Icon(Icons.play_circle_fill, size: 48, color: Colors.white),
          ],
        ),
        5.verticalSpace,
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// New screen that shows both images stacked vertically with zoom/pan

class CompareImagesScreen extends StatelessWidget {
  final String beforeUrl;
  final String afterUrl;

  const CompareImagesScreen({super.key, required this.beforeUrl, required this.afterUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ClipRect(
              // <-- Clip upper half
              child: Container(
                color: Colors.black,
                child: PhotoView(
                  imageProvider: MemoryImage(base64Decode(beforeUrl)),
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  loadingBuilder: (context, event) => const Center(child: LottieLoader()),
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 100, color: Colors.grey)),
                ),
              ),
            ),
          ),
          const Divider(height: 2, color: Colors.black),
          Expanded(
            child: ClipRect(
              // <-- Clip lower half
              child: Container(
                color: Colors.black,
                child: PhotoView(
                  imageProvider: MemoryImage(base64Decode(afterUrl)),
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  loadingBuilder: (context, event) => const Center(child: LottieLoader()),
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 100, color: Colors.grey)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple model for before/after image pair
class ImagePair {
  final String before;
  final String after;
  final bool isVideo;

  ImagePair({required this.before, required this.after, this.isVideo = false});
}
