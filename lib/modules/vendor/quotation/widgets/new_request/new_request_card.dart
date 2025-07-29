import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NewRequestCard extends StatelessWidget {
  final VendorQuotationRequestData request;
  final VoidCallback? onQuotationTap;

  const NewRequestCard({
    super.key,
    required this.request,
    this.onQuotationTap,
  });

  @override
  Widget build(BuildContext context) {
    // Fallbacks if API data is missing
    final customerName =  "Ali Hassan";
    final serviceName =  "Plumbing";
    final remarks = request.remarks?.toString() ?? "Leakage in bathroom sink"; // Example placeholder

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context, customerName),
          10.verticalSpace,
          _buildCategoryRow(serviceName),
          if (remarks.isNotEmpty) ...[
            10.verticalSpace,
            Text(remarks, style: AppFonts.text14.regular.style, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
          10.verticalSpace,
          Text("Job ID: ${request.jobId ?? '-'}", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, String customerName) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                customerName,
                style: AppFonts.text16.semiBold.style,
              ),
              10.horizontalSpace,
              _buildPhoneIcon(),
            ],
          ),
        ),
        CustomButton(
          height: 32.h,
          fullWidth: false,
          backgroundColor: AppColors.white,
          borderColor: AppColors.primary,
          textStyle: AppFonts.text14.regular.style,
          text: 'Add Quotation',
          onPressed: onQuotationTap ?? () {},
        ),
      ],
    );
  }

  Widget _buildCategoryRow(String serviceName) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xfffdf5e7),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(
            LucideIcons.wrench,
            color: Colors.orange,
            size: 18,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          serviceName,
          style: AppFonts.text14.medium.style,
        ),
      ],
    );
  }

  Widget _buildPhoneIcon() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xffeff7ef),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.green),
          ),
          child: const Icon(
            Icons.phone,
            color: Colors.green,
            size: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        Row(
          children: [
            const Icon(LucideIcons.clock, size: 16, color: Colors.grey),
            SizedBox(width: 6.w),
            Text(
              request.createdDate?.toString() ?? "3 July 2025",
              style: AppFonts.text12.regular.style,
            ),
          ],
        ),
        const Spacer(),
        if (request.active == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Color(0xffe7f3f9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'ACTIVE',
              style: AppFonts.text12.semiBold.blue.style,
            ),
          ),
      ],
    );
  }
}
