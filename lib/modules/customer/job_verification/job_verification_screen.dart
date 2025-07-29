import 'package:community_app/modules/customer/job_verification/expand_video_player.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

import 'package:community_app/modules/customer/job_verification/job_verification_notifier.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:video_player/video_player.dart';

class JobVerificationScreen extends StatelessWidget {
  const JobVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobVerificationNotifier(),
      child: Consumer<JobVerificationNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            appBar: CustomAppBar(),
            drawer: CustomDrawer(),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.payment);
                  },
                  text: "Proceed Payment",
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
                  _buildBeforeAfterPairs(context, notifier, notifier.imagePairs),
                  10.verticalSpace,
                  Divider(),
                  10.verticalSpace,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: AppStyles.commonDecoration,
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Feedback:", style: AppFonts.text14.bold.style),
                        10.verticalSpace,
                        Text(
                          "The plumbing repair in your kitchen has been completed. We replaced the faulty pipe and ensured there are no leaks. We recommend monitoring the water pressure over the next week. Thank you for trusting us.",
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
        },
      ),
    );
  }

  Widget _buildBeforeAfterPairs(BuildContext context, JobVerificationNotifier notifier, List<ImagePair> pairs) {
    if (pairs.isEmpty) return const Text("No image pairs available");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pairs.length,
        separatorBuilder: (_, __) => SizedBox(height: 30.h),
        itemBuilder: (context, index) {
          final pair = pairs[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Before image/video + label
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (pair.isVideo) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ExpandedMediaViewer(isVideo: true)),
                      );
                    }
                  },
                  child: _buildImageWithLabel(
                    label: "Before",
                    imageUrl: pair.before,
                    isVideo: pair.isVideo,
                    controller: notifier.videoController,
                  ),
                ),
              ),
              10.horizontalSpace,
              Icon(LucideIcons.arrowRight, size: 28.sp),
              10.horizontalSpace,
              // After image + label
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (pair.isVideo) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ExpandedMediaViewer(isVideo: true)),
                      );
                    }
                  },
                  child: _buildImageWithLabel(
                    label: "After",
                    imageUrl: pair.after,
                    isVideo: pair.isVideo,
                    controller: notifier.videoController,
                  ),
                ),
              ),
              if (!pair.isVideo) ...[
                10.horizontalSpace,
                // Compare button
                CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompareImagesScreen(beforeUrl: pair.before, afterUrl: pair.after),
                      ),
                    );
                  },
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.primary,
                  textStyle: AppFonts.text14.regular.style,
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  fullWidth: false,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isVideo && controller != null && controller.value.isInitialized
                  ? SizedBox(height: 100.h, width: 100.w, child: VideoPlayer(controller))
                  : !isVideo
                  ? Image.network(
                      imageUrl,
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                      },
                    )
                  : Container(
                      height: 100.h,
                      width: 100.w,
                      color: Colors.black12,
                      child: const Center(child: CircularProgressIndicator()),
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
      appBar: AppBar(title: const Text("Compare Images")),
      body: Column(
        children: [
          Expanded(
            child: ClipRect(
              // <-- Clip upper half
              child: Container(
                color: Colors.black,
                child: PhotoView(
                  imageProvider: NetworkImage(beforeUrl),
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
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
                  imageProvider: NetworkImage(afterUrl),
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
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
