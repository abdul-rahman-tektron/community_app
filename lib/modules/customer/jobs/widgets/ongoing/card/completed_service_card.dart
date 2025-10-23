import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/modules/customer/jobs/jobs_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class CompletedServiceCard extends StatelessWidget {
  final CustomerOngoingJobsData service;

  const CompletedServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceId(),
          20.verticalSpace,
          _buildProgressBar(),
          20.verticalSpace,
          _buildCheckProgressButton(context),
        ],
      ),
    );
  }

  Widget _buildServiceId() {
    return Row(
      children: [
        Expanded(child: Text(service.serviceName ?? "", style: AppFonts.text16.bold.style)),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "#${service.jobId ?? 'N/A'}", style: AppFonts.text14.regular.style),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconBox() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xffeff7ef),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(LucideIcons.circleCheckBig300, color: Colors.green, size: 22),
    );
  }

  Widget _buildCheckProgressButton(BuildContext context) {
    return CustomButton(
      text: service.status == AppStatus.jobVerifiedPaymentPending.name
          ? "Initiate Payment"
          : service.status == AppStatus.paymentCompleted.name
          ? "Add Feedback"
          : "Verify Progress",
      backgroundColor: AppColors.white,
      borderColor: AppColors.primary,
      textStyle: AppFonts.text14.regular.style,
      onPressed: () {
        final notifier = context.read<JobsNotifier>();

        String route;
        dynamic argument = service.jobId;

        if (service.status == AppStatus.jobVerifiedPaymentPending.name) {
          route = AppRoutes.payment;
          argument = {"jobId": service.jobId, "vendorId" : service.customerId};
        } else if (service.status == AppStatus.paymentCompleted.name) {
          route = AppRoutes.feedback;
        } else {
          print("Entered sana");
          route = AppRoutes.jobVerification;
          argument = {"jobId": service.jobId, "vendorId" : service.customerId};
        }

        print("argument");
        print(argument);
        print(service.status);

        Navigator.pushNamed(context, route, arguments: argument).then((_) {
          notifier.initializeData();
        });
      },
      height: 35,
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        _buildIconBox(),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service.status ?? "", style: AppFonts.text14.regular.style),
              5.verticalSpace,
              CustomLinearProgressIndicator(
                percentage: AppStatus.fromName(service.status ?? "")?.percentage ?? 0, // Static or customize as needed
                borderRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
