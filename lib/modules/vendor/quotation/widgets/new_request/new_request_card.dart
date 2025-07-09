import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NewRequestCard extends StatelessWidget {
  final NewRequestModel request;
  final VoidCallback? onQuotationTap;

  const NewRequestCard({
    super.key,
    required this.request,
    this.onQuotationTap,
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
          _buildTopRow(context),
          10.verticalSpace,
          _buildCategoryRow(),
          if (request.remarks.isNotEmpty) ...[
            10.verticalSpace,
            Text(request.remarks, style: AppFonts.text14.regular.style),
          ],
          10.verticalSpace,
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                request.customerName,
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

  Widget _buildCategoryRow() {
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
          request.category.name,
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
            border: Border.all(color: Colors.green)
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
              request.dateTime.formatDateTime(withTime: true),
              style: AppFonts.text12.regular.style,
            ),
          ],
        ),
        const Spacer(),
        if (request.isNew)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Color(0xffe7f3f9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'NEW',
              style: AppFonts.text12.semiBold.blue.style,
            ),
          ),
      ],
    );
  }
}
