import 'package:community_app/modules/customer/top_vendors/top_vendors_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/ratings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class TopVendorsScreen extends StatelessWidget {
  const TopVendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopVendorsNotifier(),
      child: Consumer<TopVendorsNotifier>(
        builder: (_, notifier, __) => SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(),
            persistentFooterButtons: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                  text: "Proceed",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.quotationList);
                  },
                ),
              ),
            ],
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Top Vendors", style: AppFonts.text20.semiBold.style),
                              _buildGradientUnderline("Top Vendors", AppFonts.text20.semiBold.style),
                            ],
                          ),
                        ),
                        _buildBackButton(context),
                      ],
                    ),
                  ),

                  10.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Select Vendors to provide the best quotation for the Service",
                      style: AppFonts.text16.regular.style,
                    ),
                  ),
                  10.verticalSpace,
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: 5,
                    // five cards
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) => _vendorCard(ctx, notifier, i),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Icon(LucideIcons.arrowLeft),
        ),
      ),
    );
  }

  Widget _vendorCard(BuildContext context, TopVendorsNotifier notifier, int index) {
    final bool isSelected = notifier.isSelected(index);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: AppStyles.commonDecoration.copyWith(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          _vendorImage(),
          _vendorInfo(index),
          _footerActionButton(notifier, index, isSelected),
        ],
      ),
    );
  }


  /// Image
  Widget _vendorImage() {
    return SizedBox(
      height: 130.h,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: SizedBox.expand(child: Image.asset(AppImages.loginImage, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildGradientUnderline(String text, TextStyle style) {
    final textWidth = _getTextWidth(text, style);

    return Container(
      height: 2,
      width: textWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primary.withOpacity(0.5),
            AppColors.primary,
            AppColors.primary.withOpacity(0.5),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  /// Info
  Widget _vendorInfo(int index) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vendor Name', style: TextStyle(fontSize: 16)),
          const Text('Vendor Address', style: TextStyle(color: Colors.grey, fontSize: 13)),
          8.verticalSpace,
          Row(
            children: const [
              Text('4.5'),
              SizedBox(width: 4),
              RatingsHelper(rating: 4.5),
            ],
          ),
        ],
      ),
    );
  }


  Widget _footerActionButton(TopVendorsNotifier notifier, int index, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: CustomButton(
        onPressed: () => notifier.toggle(index),
        icon: isSelected ? Icons.check : null,
        iconOnLeft: true,
        backgroundColor: Colors.white,
        borderColor: AppColors.primary,
        text: isSelected ? 'Selected' : 'Select',
        textStyle: isSelected ? AppFonts.text16.medium.style : AppFonts.text16.medium.style,
      ),
    );
  }


  /// Round multi‑select toggle (top‑right)
  Widget _selectCircle(TopVendorsNotifier notifier, int index) {
    final bool active = notifier.isSelected(index);
    return GestureDetector(
      onTap: () => notifier.toggle(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? AppColors.primary : Colors.transparent,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Icon(Icons.check, size: 25, color: active ? AppColors.white : AppColors.primary),
      ),
    );
  }
}
