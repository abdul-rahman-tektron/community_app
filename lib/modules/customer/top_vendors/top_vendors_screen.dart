import 'dart:convert';

import 'package:community_app/core/model/customer/top_vendors/top_vendors_response.dart';
import 'package:community_app/modules/customer/top_vendors/top_vendors_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/ratings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class TopVendorsScreen extends StatelessWidget {
  final int? jobId;
  final int? serviceId;
  const TopVendorsScreen({super.key, this.jobId, this.serviceId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopVendorsNotifier(jobId: jobId, serviceId: serviceId),
      child: Consumer<TopVendorsNotifier>(
        builder: (_, notifier, __) => SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                  text: "Proceed",
                  onPressed: notifier.selectedVendorIds.isNotEmpty
                      ? () => notifier.apiQuotationRequest(context)
                      : null,
                ),
              ),
            ],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button & title
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("Top Vendors", style: AppFonts.text20.semiBold.style),
                      ),
                    ],
                  ),
                ),
                5.verticalSpace,
                // Selection count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "${notifier.selectedCount} vendors selected",
                    style: AppFonts.text16.regular.style.copyWith(color: AppColors.primary),
                  ),
                ),
                10.verticalSpace,
                // Sub heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Select Vendors to provide the best quotation for the Service",
                    style: AppFonts.text16.regular.style,
                  ),
                ),
                10.verticalSpace,
                // Scrollable List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: notifier.topVendors.length,
                      itemBuilder: (ctx, i) {
                        final vendor = notifier.topVendors[i];
                        return _vendorCard(ctx, notifier, i, vendor);
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Back Button
  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: const Icon(LucideIcons.arrowLeft),
        ),
      ),
    );
  }

  /// Vendor Card
  Widget _vendorCard(BuildContext context, TopVendorsNotifier notifier, int index, TopVendorResponse vendor) {
    final bool isSelected = notifier.isSelected(index);

    return GestureDetector(
      onTap: () => notifier.toggle(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 1,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(vendor.image ?? ""),
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.vendorName ?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(vendor.address ?? "", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text("vendor.distance", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(vendor.rating ?? "0", style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 5),
                      RatingsHelper(rating: vendor.rating ?? 0),
                      const SizedBox(width: 3),
                    Text('(${vendor.reviewCount ?? "0"})', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
