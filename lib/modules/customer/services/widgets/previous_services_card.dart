import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PreviousServiceCard extends StatelessWidget {
  final ServiceModel service;

  const PreviousServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(12),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          10.verticalSpace,
          _buildDateTimeRow(),
          15.verticalSpace,
          _buildProductList(),
          15.verticalSpace,
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(child: _buildServiceId()),
        _buildProgressText(service.progressStatus ?? 'N/A'),
      ],
    );
  }

  Widget _buildServiceId() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "Service ID: ", style: AppFonts.text16.semiBold.style),
          TextSpan(text: "#${service.id}", style: AppFonts.text16.regular.style),
        ],
      ),
    );
  }

  Widget _buildProgressText(String progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xffeff7ef), borderRadius: BorderRadius.circular(10)),
      child: Text(progress, style: AppFonts.text14.regular.style),
    );
  }

  Widget _buildDateTimeRow() {
    final date = service.date.formatDate();
    final time = service.date.formatTime();

    return Row(
      children: [
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.calendar,
            label: date,
            bgColor: const Color(0xfffdf5e7),
            iconColor: Colors.orange,
          ),
        ),
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.clock,
            label: time,
            bgColor: const Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
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
        Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
      ],
    );
  }

  Widget _iconBox({required IconData icon, required Color bgColor, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildProductList() {
    final products = service.productUsed ?? [];

    if (products.isEmpty) {
      return Text("No product used", style: AppFonts.text14.regular.style);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...products.map(
          (product) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Color(0xFFE6E6E6), borderRadius: BorderRadius.circular(5)),
                  child: Text("${product.quantity}", style: AppFonts.text14.regular.style),
                ),
                10.horizontalSpace,
                Expanded(flex: 4, child: Text(product.name, style: AppFonts.text14.regular.style)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: "View Details",
            height: 35,
            onPressed: () {
              // Handle view details
            },
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: CustomButton(
            text: "Get Help",
            height: 35,
            backgroundColor: AppColors.white,
            borderColor: AppColors.primary,
            textStyle: AppFonts.text14.regular.style,
            onPressed: () {
              // Handle get help
            },
          ),
        ),
      ],
    );
  }
}
