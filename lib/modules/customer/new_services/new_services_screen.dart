import 'dart:io';

import 'package:community_app/modules/customer/new_services/new_services_notifier.dart';
import 'package:community_app/modules/vendor/registration/registration_trading.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_search_dropdown.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Need a hand with something?", style: AppFonts.text18.semiBold.style,),
                5.verticalSpace,
                Text("Just share the details—we’ve got you.", style: AppFonts.text16.regular.style,),
                25.verticalSpace,
                CustomSearchDropdown<String>(
                  fieldName: "Category",
                  hintText: "Select Category",
                  controller: newServicesNotifier.categoryController,
                  items: newServicesNotifier.categoryDropdownData,
                  currentLang: 'en', // You need to inject language if needed
                  itemLabel: (item, lang) => item, // Simplified for example
                  onSelected: (String? menu) {
                    newServicesNotifier.setCategory(menu);
                  },
                ),
                15.verticalSpace,
                CustomTextField(controller: newServicesNotifier.issueController, fieldName: "Issue"),
                15.verticalSpace,
                CustomTextField(
                    controller: newServicesNotifier.expectedDateController, fieldName: "Expected Date and Time", keyboardType: TextInputType.datetime, needTime: true,),
                15.verticalSpace,
                CustomTextField(controller: newServicesNotifier.mobileController, fieldName: "Mobile Number"),
                15.verticalSpace,
                CustomSearchDropdown<String>(
                  fieldName: "Priority",
                  hintText: "Select Priority",
                  controller: newServicesNotifier.priorityController,
                  items: newServicesNotifier.priorityDropdownData,
                  currentLang: 'en', // You need to inject language if needed
                  itemLabel: (item, lang) => item, // Simplified for example
                  onSelected: (String? menu) {
                    newServicesNotifier.setPriority(menu);
                  },
                ),
                25.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Issue Photo or Video',
                            style: AppFonts.text14.regular.style,
                          ),
                          5.verticalSpace,
                          Text(
                            newServicesNotifier.uploadedFile != null
                                ? newServicesNotifier.uploadedFileName ?? ""
                                : 'No file selected',
                            style: AppFonts.text14.regular.grey.style,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    15.horizontalSpace,
                    CustomUploadButton(
                      text: "Upload",
                      backgroundColor: AppColors.background,
                      textStyle: AppFonts.text14.regular.style,
                      onPressed: () {
                        newServicesNotifier.pickImageOrVideo();
                      },
                    ),
                  ],
                ),
                30.verticalSpace,
                CustomButton(
                  text: "Proceed",
                  onPressed: () {

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
