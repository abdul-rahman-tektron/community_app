import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/modules/customer/services/widgets/completed_service_card.dart';
import 'package:community_app/modules/customer/services/widgets/in_progress_service_card.dart';
import 'package:community_app/modules/customer/services/widgets/tracking_service_card.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingServicesWidget extends StatelessWidget {
  final List<ServiceModel> upcomingServices;

  const UpcomingServicesWidget({super.key, required this.upcomingServices});

  @override
  Widget build(BuildContext context) {
    // Group services by status
    final Map<UpcomingServiceStatus, List<ServiceModel>> grouped = {
      for (var status in UpcomingServiceStatus.values)
        status: upcomingServices.where((s) => s.status == status).toList()
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text("Upcoming Services", style: AppFonts.text18.semiBold.style,),
        ),
        15.verticalSpace,
        ...UpcomingServiceStatus.values.map((status) {
          final services = grouped[status]!;
          if (services.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...services.map((service) {
                switch (status) {
                  case UpcomingServiceStatus.tracking:
                    return TrackingServiceCard(service: service);
                  case UpcomingServiceStatus.inProgress:
                    return InProgressServiceCard(service: service);
                  case UpcomingServiceStatus.completed:
                    return CompletedServiceCard(service: service);
                }
              }),
              15.verticalSpace,
            ],
          );
        }),
      ]
    );
  }
}
