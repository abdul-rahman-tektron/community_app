import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CustomButton(text: "New Service", onPressed: () {},),
            ],
          ),
        ),
      ),
    );
  }
}
