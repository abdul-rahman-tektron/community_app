
import 'package:community_app/modules/vendor/quotation/widgets/updated_quotation/updated_quotation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatedQuotationScreen extends StatelessWidget {
  const UpdatedQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UpdateQuotationNotifier(),
      child: Consumer<UpdateQuotationNotifier>(
        builder: (context, updateQuotationNotifier, child) {
          return buildBody(context, updateQuotationNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, UpdateQuotationNotifier updateQuotationNotifier) {
    return Column(children: [Text("New Request Screen")]);
  }
}
