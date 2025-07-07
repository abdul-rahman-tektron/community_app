import 'package:community_app/modules/customer/new_services/new_services_notifier.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewServicesScreen extends StatelessWidget {
  const NewServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewServicesNotifier(),
      child: Consumer<NewServicesNotifier>(
        builder: (context, servicesNotifier, child) {
          return buildBody(context, servicesNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, NewServicesNotifier newServicesNotifier) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // CustomTextField(controller: newServicesNotifier., fieldName: fieldName)
            ],
          ),
        ),
      ),
    );
  }
}
