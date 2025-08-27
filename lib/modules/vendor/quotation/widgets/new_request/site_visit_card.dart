import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:community_app/utils/extensions.dart';

class SiteVisitCard extends StatelessWidget {
  final VendorQuotationRequestData request;
  final VoidCallback? onQuotationTap;
  final VoidCallback? onCallTap;

  const SiteVisitCard({
    super.key,
    required this.request,
    this.onQuotationTap,
    this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context, request.customerName ?? "Customer Name"),
          _buildCategoryRow(request.serviceName ?? "Service Name"),
          if (request.remarks?.isNotEmpty ?? false) ...[
            10.verticalSpace,
            Text("Remarks: ${request.remarks ?? "-"}", style: AppFonts.text14.regular.style, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
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
        Text("#${request.jobId ?? '-'}", style: AppFonts.text14.regular.style),
      ],
    );
  }

  Widget _buildCategoryRow(String serviceName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          serviceName,
          style: AppFonts.text14.medium.style,
        ),
      ],
    );
  }

  Widget _buildPhoneIcon() {
    return GestureDetector(
      onTap: onCallTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xffeff7ef),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.phone,
              color: Colors.green,
              size: 15,
            ),
            3.horizontalSpace,
            Text("Call", style: AppFonts.text14.regular.style.copyWith(color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xffe7f3f9),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text("Site Visit ${(request.isAcceptedByCustomer ?? false) ? "Accepted" : "Requested"}", style: AppFonts.text14.regular.style.copyWith(color: Colors.blue)),
              ),
              10.verticalSpace,
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xfffdf5e7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      LucideIcons.calendar300,
                      color: Colors.orange,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    request.expectedDate != null
                        ? request.expectedDate!.formatDate()
                        : "-",
                    style: AppFonts.text12.regular.style,
                  )
                ],
              ),
            ],
          ),
        ),
        if(request.isAcceptedByCustomer ?? false) CustomButton(
          height: 30.h,
          fullWidth: false,
          backgroundColor: AppColors.white,
          borderColor: AppColors.primary,
          textStyle: AppFonts.text14.regular.style,
          text: 'Assign Employee',
          onPressed: onQuotationTap ?? () {},
        ),
      ],
    );
  }
}
