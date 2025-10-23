import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class QuotationCard extends StatelessWidget {
  final VendorQuotationRequestData quotation;
  final VoidCallback? onViewDetails;
  final VoidCallback? onResend;

  const QuotationCard({super.key, required this.quotation, this.onViewDetails, this.onResend});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(),
          3.verticalSpace,
          Text(quotation.serviceName ?? "-", style: AppFonts.text14.medium.style),
          if (quotation.remarks?.isNotEmpty ?? false) ...[
            10.verticalSpace,
            Text(
              "Remarks: ${quotation.remarks ?? "-"}",
              style: AppFonts.text14.regular.style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          10.verticalSpace,
          _buildStatusRow(),
          10.verticalSpace,
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        Expanded(child: Text(quotation.customerName ?? "", style: AppFonts.text16.semiBold.style)),
        Text("#${quotation.jobId ?? '-'}", style: AppFonts.text14.regular.style),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "AED ", style: AppFonts.text14.semiBold.style),
                TextSpan(
                  text: (quotation.quotationAmount ?? 0).toStringAsFixed(2),
                  style: AppFonts.text20.semiBold.style,
                ),
              ],
            ),
          ),
        ),
        _buildStatusTag(
          ((quotation.status ?? "") == AppStatus.vendorQuotationRejected.name)
              ? "Rejected"
              : quotation.quotationResponseStatus ?? "Status",
        ),
      ],
    );
  }

  Widget _buildStatusTag(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case "rejected":
        bgColor = const Color(0xffffeded);
        textColor = Colors.red;
        break;
      case "approved":
        bgColor = const Color(0xffe7f9ed);
        textColor = Colors.green;
        break;
      default:
        bgColor = const Color(0xfffdf5e7);
        textColor = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.toCapitalize(),
        style: AppFonts.text12.semiBold.style.copyWith(color: textColor),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xfffdf5e7),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(LucideIcons.calendar300, color: Colors.orange, size: 18),
              ),
              SizedBox(width: 7.w),
              Text(
                quotation.expectedDate != null ? quotation.expectedDate!.formatDate() : "-",
                style: AppFonts.text12.regular.style,
              ),
            ],
          ),
        ),
        if ((quotation.status ?? "") != AppStatus.vendorQuotationRejected.name) ...[
          CustomButton(
            text: "View Details",
            height: 32,
            borderColor: AppColors.primary,
            backgroundColor: AppColors.white,
            textStyle: AppFonts.text14.regular.style,
            fullWidth: false,
            onPressed: onViewDetails,
          ),
        ],
        if ((quotation.status ?? "") == AppStatus.vendorQuotationRejected.name) ...[
          10.horizontalSpace,
          CustomButton(
            text: "Resend",
            fullWidth: false,
            height: 32,
            borderColor: AppColors.error,
            backgroundColor: AppColors.white,
            textStyle: AppFonts.text14.regular.red.style,
            onPressed: onResend ?? () {},
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          text: "View Details",
          height: 35,
          borderColor: AppColors.primary,
          backgroundColor: AppColors.white,
          textStyle: AppFonts.text14.regular.style,
          fullWidth: false,
          onPressed: onViewDetails,
        ),
      ],
    );
  }

  Widget _iconLabelRow({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Row(
      children: [
        _iconBox(icon: icon, bgColor: bgColor, iconColor: iconColor),
        10.horizontalSpace,
        Text(label, style: AppFonts.text12.regular.style),
      ],
    );
  }

  Widget _iconBox({required IconData icon, required Color bgColor, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, color: iconColor, size: 15),
    );
  }
}
