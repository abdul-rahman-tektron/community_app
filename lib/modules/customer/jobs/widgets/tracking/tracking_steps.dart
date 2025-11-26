import 'package:Xception/core/model/customer/job/job_status_tracking/job_status_tracking_response.dart';
import 'package:Xception/core/model/customer/job/job_status_tracking/jobs_status_response.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TrackingStepsWidget extends StatelessWidget {
  final List<JobStatusResponse>? jobStatus;
  final JobStatusTrackingData? currentStep;

  const TrackingStepsWidget({
    super.key,
    required this.currentStep,
    required this.jobStatus,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    // Find current step index
    final currentIndex = jobStatus?.indexWhere(
          (element) =>
      element.status?.toLowerCase().trim() ==
          currentStep?.status?.toLowerCase().trim(),
    ) ??
        -1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentIndex != -1 && scrollController.hasClients) {
        final offset = currentIndex * 60.0; // Approx tile height

        try {
          scrollController.animateTo(
            offset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } catch (_) {
          // Fallback in case animation fails
          scrollController.jumpTo(offset);
        }
      }
    });

    return Expanded(
      child: (jobStatus == null || jobStatus!.isEmpty)
          ? const Center(child: LottieLoader())
          : Scrollbar(
        controller: scrollController,
        radius: Radius.circular(5.r),
        thumbVisibility: true,
        child: ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.zero,
          reverse: true,
          itemCount: jobStatus!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final statusItem = jobStatus![index];
            final isCompleted =
                index <= currentIndex && currentIndex != -1;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xffd9ebdb)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  isCompleted ? LucideIcons.check : LucideIcons.clock,
                  color: isCompleted ? Colors.green : Colors.grey,
                  size: 18,
                ),
              ),
              title: Text(
                statusItem.status ?? "",
                style: AppFonts.text16.regular.style,
              ),
            );
          },
        ),
      ),
    );
  }
}
