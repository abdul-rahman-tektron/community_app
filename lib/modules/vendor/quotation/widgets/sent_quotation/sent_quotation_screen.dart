import 'package:community_app/modules/vendor/quotation/widgets/sent_quotation/sent_quotation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SentQuotationScreen extends StatelessWidget {
  const SentQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SentQuotationNotifier(),
      child: Consumer<SentQuotationNotifier>(
        builder: (context, sentQuotationNotifier, child) {
          return buildBody(context, sentQuotationNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, SentQuotationNotifier sentQuotationNotifier) {
    return Column(children: [Text("New Request Screen")]);
  }
}
