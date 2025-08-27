import 'package:community_app/core/model/common/dropdown/priority_dropdown_response.dart';
import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/modules/customer/new_services/new_services_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:community_app/utils/widgets/custom_search_dropdown.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class NewServicesScreen extends StatelessWidget {
  final int? vendorId;
  final String? vendorName;
  final String? serviceName;
  const NewServicesScreen({super.key, this.vendorId, this.vendorName, this.serviceName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewServicesNotifier(vendorId, vendorName, serviceName),
      child: Consumer<NewServicesNotifier>(
        builder: (context, servicesNotifier, child) {
          return buildBody(context, servicesNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, NewServicesNotifier newServicesNotifier) {
    print("serviceName");
    print(serviceName);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: newServicesNotifier.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Need a hand with something?", style: AppFonts.text18.semiBold.style,),
                  5.verticalSpace,
                  Text("Just share the details and we’ve got you.", style: AppFonts.text16.regular.style,),
                  25.verticalSpace,
                  CustomSearchDropdown<ServiceDropdownData>(
                    fieldName: "Service",
                    hintText: "Select Service",
                    isEnable: serviceName == null,
                    controller: newServicesNotifier.serviceController,
                    items: newServicesNotifier.serviceDropdownData,
                    currentLang: 'en', // You need to inject language if needed
                    itemLabel: (item, lang) => item.serviceName!, // Simplified for example
                    onSelected: (ServiceDropdownData? menu) {
                      newServicesNotifier.setCategory(menu);
                    },
                  ),
                  15.verticalSpace,
                  CustomTextField(
                    controller: newServicesNotifier.expectedDateController,
                    fieldName: "Preferred Date",
                    keyboardType: TextInputType.datetime,
                    startDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  ),
                  15.verticalSpace,
                  CustomTextField(controller: newServicesNotifier.mobileNumberController,
                    fieldName: "Mobile Number",
                    keyboardType: TextInputType.phone,),
                  15.verticalSpace,
                  CustomSearchDropdown<PriorityDropdownData>(
                    fieldName: "Priority",
                    hintText: "Select Priority",
                    controller: newServicesNotifier.priorityController,
                    items: newServicesNotifier.priorityDropdownData,
                    currentLang: 'en', // You need to inject language if needed
                    itemLabel: (item, lang) => item.name!, // Simplified for example
                    onSelected: (PriorityDropdownData? menu) {
                      newServicesNotifier.setPriority(menu);
                    },
                  ),
                  15.verticalSpace,
                  CustomTextField(controller: newServicesNotifier.remarksController,
                    fieldName: "Job Description",
                    isMaxLines: true,
                    hintText: "Enter Job Description",),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Transform.scale(
                  //         scale: 0.9,
                  //         child: Switch(
                  //           padding: EdgeInsets.zero,
                  //           activeColor: AppColors.secondary,
                  //           thumbColor: WidgetStateProperty.all(AppColors.white),
                  //           trackColor: WidgetStateProperty.resolveWith((states) {
                  //             return newServicesNotifier.siteVisitOption
                  //                 ? AppColors.secondary
                  //                 : AppColors.secondary.withOpacity(0.3);
                  //           }),
                  //           trackOutlineColor: WidgetStateProperty.all(AppColors.white),
                  //           value: newServicesNotifier.siteVisitOption,
                  //           onChanged: (bool value) {
                  //             newServicesNotifier.setSiteVisitOption(value);
                  //           },
                  //         ),
                  //       ),
                  //       10.horizontalSpace,
                  //       Expanded(
                  //         child: Row(
                  //           children: [
                  //             Text.rich(
                  //               TextSpan(
                  //                 children: [
                  //                   TextSpan(
                  //                     text: "Site Visit Required? ",
                  //                     style: AppFonts.text14.regular.style,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             Tooltip(
                  //               message: "If you are unsure about the issue, the vendor will visit and inspect the site before providing the final quotation.",
                  //               triggerMode: TooltipTriggerMode.tap,
                  //               showDuration: Duration(seconds: 5),
                  //               child: Icon(LucideIcons.info, size: 18),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Attachments',
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
                      newServicesNotifier.submitServiceRequest(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
