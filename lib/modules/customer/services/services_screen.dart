import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/modules/customer/services/widgets/new_service_button.dart';
import 'package:community_app/modules/customer/services/widgets/previous_services.dart';
import 'package:community_app/modules/customer/services/widgets/upcoming_services.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ServicesNotifier(),
      child: Consumer<ServicesNotifier>(
        builder: (context, servicesNotifier, child) {
          return buildBody(context, servicesNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, ServicesNotifier servicesNotifier) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewServiceButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.newServices);
                  },
                ),
                20.verticalSpace,
                UpcomingServicesWidget(
                  upcomingServices: servicesNotifier.upcomingServices,
                ),
                20.verticalSpace,
                PreviousServicesWidget(
                  previousServices: servicesNotifier.previousServices,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
