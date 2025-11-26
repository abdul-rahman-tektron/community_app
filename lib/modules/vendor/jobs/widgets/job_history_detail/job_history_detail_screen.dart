import 'dart:convert';
import 'dart:io';
import 'package:Xception/core/model/vendor/jobs/vendor_history_detail_response.dart';
import 'package:Xception/modules/vendor/jobs/widgets/job_history_detail/job_history_detail_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/styles.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:Xception/utils/helpers/screen_size.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:Xception/utils/widgets/ratings_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobHistoryDetailScreen extends StatelessWidget {
  final int jobId;
  const JobHistoryDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobHistoryDetailNotifier(jobId),
      child: Consumer<JobHistoryDetailNotifier>(
        builder: (context, notifier, _) {
          return LoadingOverlay<JobHistoryDetailNotifier>(
            child: buildBody(context, notifier),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, JobHistoryDetailNotifier notifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              children: [
                _buildJobDescription(context, notifier),
                15.verticalSpace,
                _buildAfterPhotos(notifier),
                15.verticalSpace,
                _buildNotesSection(notifier),
                15.verticalSpace,
                _buildAmountSection(notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Back Button AppBar
  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: const Icon(LucideIcons.arrowLeft),
            ),
          ),
          15.horizontalSpace,
          Text("Job History Detail", style: AppFonts.text18.semiBold.style),
        ],
      ),
    );
  }

  /// Job Description Section
  Widget _buildJobDescription(BuildContext context, JobHistoryDetailNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notifier.jobDetail.customerName ?? "", style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text(notifier.jobDetail.serviceName ?? "", style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: notifier.jobDetail.phoneNumber ?? "",
            bgColor: const Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: notifier.jobDetail.address ?? "",
            bgColor: const Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text("Requested Date: ${notifier.jobDetail.expectedDate?.formatDate() ?? ""}", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Priority: ', style: AppFonts.text14.regular.style),
                TextSpan(
                  text: notifier.jobDetail.priority ?? "",
                  style: AppFonts.text14.regular.red.style,
                ),
              ],
            ),
          ),
          10.verticalSpace,
          if (notifier.jobDetail.fileContent != null)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.imageViewer, arguments: notifier.jobDetail.fileContent);
              },
              child: Image.memory(
                notifier.jobDetail.fileBytes ?? Uint8List(0),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            ),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "Job Description: ", style: AppFonts.text14.semiBold.style),
                TextSpan(text: notifier.jobDetail.remarks ?? "", style: AppFonts.text14.regular.style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Before & After Photos
  Widget _buildAfterPhotos(JobHistoryDetailNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Before & After Photos",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        8.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifier.vendorHistoryDetailData?.completionDetails?.length ?? 0,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.8,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final pair = notifier.vendorHistoryDetailData?.completionDetails?[index];
            return _buildBeforeAfterCard(context, pair);
          },
        ),
      ],
    );
  }

  Widget _buildBeforeAfterCard(context, CompletionDetail? pair) {
    return Container(
      constraints: const BoxConstraints(minHeight: 130),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2)
            ,)

        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildImageWithLabel(context, "Before", pair?.beforePhotoUrl, false)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_forward, size: 28, color: Colors.grey),
          ),
          Expanded(child: _buildImageWithLabel(context, "After", pair?.afterPhotoUrl, false)),
        ],
      ),
    );
  }

  Widget _buildImageWithLabel(BuildContext context, String label, String? url, bool isVideo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.imageViewer, arguments: url);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(url ?? ""),
                  height: ScreenSize.width < 380 ? 75 : 90,
                  width: ScreenSize.width < 380 ? 75 : 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isVideo)
              const Positioned.fill(
                child: Center(
                  child: Icon(Icons.play_circle_fill,
                      size: 40, color: Colors.white),
                ),
              ),
          ],
        ),
        5.verticalSpace,
        Text(
          label,
          style: AppFonts.text14.regular.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Notes
  Widget _buildNotesSection(JobHistoryDetailNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Assigned Employee: ", style: AppFonts.text14.semiBold.style),
            5.horizontalSpace,
            Expanded(child: Text(notifier.vendorHistoryDetailData?.jobDetail?.assignedEmployee ?? "Test", style: AppFonts.text14.regular.style)),
          ],
        ),
       10.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notes: ", style: AppFonts.text14.semiBold.style),
            5.horizontalSpace,
            Expanded(child: Text(notifier.vendorHistoryDetailData?.jobDetail?.remarks ?? "N/A", style: AppFonts.text14.regular.style)),
          ],
        ),
        10.verticalSpace,
        Row(
          children: [
            Text("Ratings: ", style: AppFonts.text14.semiBold.style),
            5.horizontalSpace,
           RatingsHelper(rating: notifier.vendorHistoryDetailData?.jobDetail?.rating?.toDouble() ?? 0),
          ],
        ),
        Row(
          children: [
            Text("Feedback: ", style: AppFonts.text14.semiBold.style),
            5.horizontalSpace,
            Text(notifier.vendorHistoryDetailData?.jobDetail?.feedback ?? ""),
          ],
        ),
      ],
    );
  }

  /// Amount
  Widget _buildAmountSection(JobHistoryDetailNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Amount", style: AppFonts.text16.semiBold.style),
        Text("AED ${notifier.vendorHistoryDetailData?.jobDetail?.totalAmount?.toStringAsFixed(2) ?? ""}", style: AppFonts.text16.semiBold.red.style),
      ],
    );
  }

  Widget _iconLabelRow(
      {required IconData icon, required String label, required Color bgColor, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 5),
          Text(label, style: AppFonts.text14.regular.style),
        ],
      ),
    );
  }
}
