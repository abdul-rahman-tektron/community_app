import 'package:community_app/modules/customer/previous_detail/previous_detail_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class PreviousDetailScreen extends StatelessWidget {
  final int jobId;
  const PreviousDetailScreen({super.key,required this.jobId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreviousDetailNotifier(jobId),
      child: Consumer<PreviousDetailNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          return Scaffold(
            appBar: CustomAppBar(),
            persistentFooterButtons: [
              _buildActionButtons(context, notifier),
            ],
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  children: [
                    _buildJobSummary(notifier),
                    15.verticalSpace,
                    _buildVendorInfo(notifier),
                    15.verticalSpace,
                    _buildWorkDetails(notifier.imagePairs, notifier.notes),
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
  Widget _buildJobSummary(PreviousDetailNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(notifier.serviceName, style: AppFonts.text20.semiBold.style),
        5.verticalSpace,
        Text("Ref#: ${notifier.jobRef}", style: AppFonts.text14.regular.grey.style),
        5.verticalSpace,
        _infoRow("Status", notifier.status),
        _infoRow("Requested", notifier.requestedDate),
        _infoRow("Completed", notifier.completedDate ?? "-"),
        _infoRow("Priority", notifier.priority ?? "-"),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(label, style: AppFonts.text14.regular.style)),
          Text(value, style: AppFonts.text14.bold.style),
        ],
      ),
    );
  }

  /// Vendor Info
  Widget _buildVendorInfo(PreviousDetailNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: AppStyles.commonDecoration,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notifier.vendorName, style: AppFonts.text14.semiBold.style),
                5.verticalSpace,
                Text("Contact: ${notifier.vendorPhone}", style: AppFonts.text14.regular.style),
              ],
            ),
          ),
          CustomButton(
            height: 40,
            onPressed: () => notifier.callVendor(),
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
  Widget _buildWorkDetails(List<ImagePair> images, String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Work Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        10.verticalSpace,
        _buildAfterPhotos(images),
        10.verticalSpace,
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

  Widget _buildAfterPhotos(List<ImagePair> imagePairs) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imagePairs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.9,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final pair = imagePairs[index];
        return _buildBeforeAfterCard(pair);
      },
    );
  }

  Widget _buildBeforeAfterCard(ImagePair pair) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppStyles.commonDecoration,
      child: Row(
        children: [
          Expanded(child: _buildImageWithLabel("Before", pair.before, pair.isVideo)),
          const Icon(Icons.arrow_forward, color: Colors.grey, size: 28),
          Expanded(child: _buildImageWithLabel("After", pair.after, pair.isVideo)),
        ],
      ),
    );
  }

  Widget _buildImageWithLabel(String label, String url, bool isVideo) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(url, height: 90, width: 90, fit: BoxFit.cover),
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
  Widget _buildBillingSection(BuildContext context, PreviousDetailNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Billing", style: AppFonts.text16.semiBold.style),
          10.verticalSpace,
          _infoRow("Total Amount:", "AED ${notifier.totalAmount.toStringAsFixed(2)}"),
          _infoRow("Payment Method:", notifier.paymentMethod),
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
          )
        ],
      ),
    );
  }

  /// Feedback
  Widget _buildFeedbackSection(BuildContext context, PreviousDetailNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Feedbacks", style: AppFonts.text16.semiBold.style),
        15.verticalSpace,
        Text("Service Feedback", style: AppFonts.text14.semiBold.style),
        10.verticalSpace,
        notifier.hasFeedback
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < notifier.serviceRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                );
              }),
            ),
            5.verticalSpace,
            Text(notifier.serviceReview, style: AppFonts.text14.regular.style),
          ],
        )
            : ElevatedButton(
          onPressed: () => notifier.addFeedback(context),
          child: const Text("Add Feedback"),
        ),
        25.verticalSpace,
        Text("Vendor Feedback", style: AppFonts.text14.semiBold.style),
        10.verticalSpace,
        notifier.hasFeedback
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < notifier.vendorRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                );
              }),
            ),
            5.verticalSpace,
            Text(notifier.vendorReview, style: AppFonts.text14.regular.style),
          ],
        )
            : ElevatedButton(
          onPressed: () => notifier.addFeedback(context),
          child: const Text("Add Feedback"),
        ),
      ],
    );
  }

  /// Actions (Rebook & Support)
  Widget _buildActionButtons(BuildContext context, PreviousDetailNotifier notifier) {
    return CustomButton(
      onPressed: () => notifier.rebookService(),
      text: "Rebook Service",
    );
  }
}
