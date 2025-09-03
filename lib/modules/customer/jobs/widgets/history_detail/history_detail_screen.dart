import 'dart:convert';

import 'package:community_app/core/model/customer/job/customer_history_detail_response.dart';
import 'package:community_app/modules/customer/jobs/widgets/history_detail/history_detail_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class HistoryDetailScreen extends StatelessWidget {
  final int? jobId;
  final int? vendorId;
  final String? vendorName;
  final String? serviceName;

  const HistoryDetailScreen({
    super.key,
    required this.jobId,
    required this.vendorId,
    required this.vendorName,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryDetailNotifier(jobId),
      child: Consumer<HistoryDetailNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Scaffold(body: Center(child: LottieLoader()));
          }

          return Scaffold(
            appBar: CustomAppBar(),
            persistentFooterButtons: [_buildActionButtons(context, notifier)],
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  children: [
                    _buildJobSummary(notifier),
                    15.verticalSpace,
                    _buildVendorInfo(notifier),
                    15.verticalSpace,
                    _buildWorkDetails(
                      notifier,
                      notifier.customerHistoryDetailData?.jobDetail?.remarks ?? "",
                    ),
                    15.verticalSpace,
                    _buildBillingSection(context, notifier),
                    15.verticalSpace,
                    _buildFeedbackSection(context, notifier),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Job Summary
  Widget _buildJobSummary(HistoryDetailNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notifier.customerHistoryDetailData?.jobDetail?.vendorName ?? "",
          style: AppFonts.text20.semiBold.style,
        ),
        5.verticalSpace,
        Text(
          "#${notifier.customerHistoryDetailData?.jobDetail?.jobId ?? ""}",
          style: AppFonts.text14.regular.grey.style,
        ),
        5.verticalSpace,
        _infoRow("Status", notifier.status),
        _infoRow(
          "Requested",
          notifier.customerHistoryDetailData?.jobDetail?.requestedDate?.formatDate() ?? "-",
        ),
        _infoRow(
          "Completed",
          notifier.customerHistoryDetailData?.jobDetail?.completedDate?.formatDate() ?? "-",
        ),
        _infoRow("Priority", notifier.customerHistoryDetailData?.jobDetail?.priority ?? "-"),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
          Text(value, style: AppFonts.text14.bold.style),
        ],
      ),
    );
  }

  /// Vendor Info
  Widget _buildVendorInfo(HistoryDetailNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: AppStyles.commonDecoration,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notifier.customerHistoryDetailData?.jobDetail?.vendorName ?? "",
                  style: AppFonts.text14.semiBold.style,
                ),
                5.verticalSpace,
                Text(
                  "Contact: ${notifier.customerHistoryDetailData?.jobDetail?.vendorPhoneNumber ?? ""}",
                  style: AppFonts.text14.regular.style,
                ),
              ],
            ),
          ),
          CustomButton(
            height: 40,
            onPressed: () => notifier.openDialer(
              notifier.customerHistoryDetailData?.jobDetail?.vendorPhoneNumber ?? "",
            ),
            icon: Icons.phone,
            iconOnLeft: true,
            backgroundColor: AppColors.white,
            borderColor: AppColors.secondary,
            textStyle: AppFonts.text14.regular.style,
            fullWidth: false,
            text: "Call",
          ),
        ],
      ),
    );
  }

  /// Work Details
  Widget _buildWorkDetails(HistoryDetailNotifier notifier, String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Work Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        5.verticalSpace,
        _buildAfterPhotos(notifier),
        10.verticalSpace,
        if (notifier.customerHistoryDetailData?.jobDetail?.employeeName?.isNotEmpty ?? false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Employee Name:", style: AppFonts.text16.semiBold.style),
              5.verticalSpace,
              Text(
                notifier.customerHistoryDetailData?.jobDetail?.employeeName ?? "",
                style: AppFonts.text14.regular.style,
              ),
              10.verticalSpace,
            ],
          ),

        if (notes.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Notes", style: AppFonts.text16.semiBold.style),
              5.verticalSpace,
              Text(notes, style: AppFonts.text14.regular.style),
            ],
          ),
      ],
    );
  }

  Widget _buildAfterPhotos(HistoryDetailNotifier notifier) {
    if (notifier.completionDetails.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifier.completionDetails.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.9,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final pair = notifier.completionDetails[index];
        return _buildBeforeAfterCard(context, pair);
      },
    );
  }

  Widget _buildBeforeAfterCard(BuildContext context, CompletionDetail pair) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppStyles.commonDecoration,
      child: Row(
        children: [
          Expanded(child: _buildImageWithLabel(context, "Before", pair.beforePhotoBytes, false)),
          const Icon(Icons.arrow_forward, color: Colors.grey, size: 28),
          Expanded(child: _buildImageWithLabel(context, "After", pair.afterPhotoBytes, false)),
        ],
      ),
    );
  }

  Widget _buildImageWithLabel(
    BuildContext context,
    String label,
    Uint8List? imageBytes,
    bool isVideo,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (imageBytes != null) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.imageViewer,
                    arguments: base64Encode(imageBytes),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageBytes != null
                    ? Image.memory(imageBytes, height: 90, width: 90, fit: BoxFit.cover)
                    : Container(
                        height: 90,
                        width: 90,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.white),
                      ),
              ),
            ),
            if (isVideo)
              const Positioned.fill(
                child: Center(child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white)),
              ),
          ],
        ),
        5.verticalSpace,
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  /// Billing
  Widget _buildBillingSection(BuildContext context, HistoryDetailNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Billing", style: AppFonts.text16.semiBold.style),
          10.verticalSpace,
          _infoRow(
            "Total Amount:",
            "AED ${notifier.customerHistoryDetailData?.jobDetail?.totalAmount?.toStringAsFixed(2) ?? ""}",
          ),
          _infoRow(
            "Payment Method:",
            notifier.customerHistoryDetailData?.jobDetail?.paymentMethod ?? "",
          ),
          10.verticalSpace,
          CustomButton(
            onPressed: () => notifier.openInvoice(context),
            iconOnLeft: true,
            fullWidth: false,
            borderColor: Colors.purple,
            backgroundColor: AppColors.white,
            icon: LucideIcons.fileText300,
            iconColor: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 35,
            radius: 50,
            text: "Download Invoice",
            textStyle: AppFonts.text14.regular.style.copyWith(color: Colors.purple),
          ),
        ],
      ),
    );
  }

  /// Feedback
  Widget _buildFeedbackSection(BuildContext context, HistoryDetailNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Feedbacks", style: AppFonts.text16.semiBold.style),
        15.verticalSpace,
        notifier.customerHistoryDetailData?.jobDetail?.rating != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index <
                                int.parse(
                                  notifier.customerHistoryDetailData?.jobDetail?.rating
                                          .toString() ??
                                      "0",
                                )
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  5.verticalSpace,
                  Text(
                    notifier.customerHistoryDetailData?.jobDetail?.feedbackComments ?? "",
                    style: AppFonts.text14.regular.style,
                  ),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }

  /// Actions (Rebook & Support)
  Widget _buildActionButtons(BuildContext context, HistoryDetailNotifier notifier) {
    return CustomButton(onPressed: () {
      Navigator.pushNamed(context, AppRoutes.newServices, arguments: {
        "vendorId": vendorId ?? "",
        "vendorName": vendorName ?? "",
        "serviceName": serviceName ?? "",
      },);
    }, text: "Rebook Service");
  }
}
