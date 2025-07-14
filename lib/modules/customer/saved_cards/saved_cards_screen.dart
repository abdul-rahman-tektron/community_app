import 'package:community_app/modules/customer/saved_cards/saved_cards_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/helpers/input_formatter.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SavedCardsScreen extends StatelessWidget {
  const SavedCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SavedCardsNotifier(context),
      child: Consumer<SavedCardsNotifier>(
        builder: (context, savedCardsNotifier, child) {
          return LoadingOverlay<SavedCardsNotifier>(
            child: buildBody(context, savedCardsNotifier),
          );
        },
      ),
    );
  }

  buildBody(BuildContext context, SavedCardsNotifier notifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Column(
            children: [
              titleWidget(),
              15.verticalSpace,
              cardHolderNameField(notifier),
              15.verticalSpace,
              cardNumberField(notifier),
              15.verticalSpace,
              Row(
                children: [
                  Expanded(child: expiryDateField(notifier)),
                  10.horizontalSpace,
                  Expanded(child: cvvField(notifier)),
                ],
              ),
              25.verticalSpace,
              saveButton(context, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return Text("Add Card Details", style: AppFonts.text20.regular.style);
  }

  Widget cardHolderNameField(SavedCardsNotifier notifier) {
    return CustomTextField(
      controller: notifier.fullNameController,
      fieldName: "Card Holder Name",
      isSmallFieldFont: true,
      keyboardType: TextInputType.name,
      // validator: (value) => Validations.validateName(null, value),
    );
  }

  Widget cardNumberField(SavedCardsNotifier notifier) {
    return CustomTextField(
      controller: notifier.cardNumberController,
      fieldName: "Card Number",
      isSmallFieldFont: true,
      keyboardType: TextInputType.number,
      inputFormatters: [CardNumberInputFormatter()],
      // validator: (value) => Validations.validateCardNumber(value),
    );
  }

  Widget expiryDateField(SavedCardsNotifier notifier) {
    return CustomTextField(
      controller: notifier.expiryDateController,
      fieldName: "Expiry Date (MM/YY)",
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      // validator: (value) => Validations.validateExpiryDate(value),
    );
  }

  Widget cvvField(SavedCardsNotifier notifier) {
    return CustomTextField(
      controller: notifier.cvvController,
      fieldName: "CVV",
      isSmallFieldFont: true,
      keyboardType: TextInputType.number,
      // validator: (value) => Validations.validateCVV(value),
    );
  }

  Widget saveButton(BuildContext context, SavedCardsNotifier notifier) {
    return CustomButton(
      text: "Save Card",
      onPressed: () => notifier.saveData(context),
    );
  }
}