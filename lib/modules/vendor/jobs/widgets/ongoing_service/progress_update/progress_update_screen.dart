import 'dart:convert';
import 'dart:io';

import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/progress_update/assign_bottom_sheet.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/progress_update/progress_update_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/dashed_border_container.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ProgressUpdateScreen extends StatelessWidget {
  final int? jobId;
  final int? customerId;
  final String? status;

  const ProgressUpdateScreen({super.key, this.jobId, this.customerId, this.status});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressUpdateNotifier(jobId, customerId, status),
      child: Consumer<ProgressUpdateNotifier>(
        builder: (context, notifier, _) {
          return LoadingOverlay<ProgressUpdateNotifier>(child: buildBody(context, notifier));
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, ProgressUpdateNotifier notifier) {
    return Scaffold(
      persistentFooterButtons: [
        if (notifier.currentPhase != JobPhase.completed) _buildPersistentButtons(context, notifier),
      ],
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            buildCustomerInfo(context, notifier),
            15.verticalSpace,
            _buildPhaseContent(context, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseContent(BuildContext context, ProgressUpdateNotifier notifier) {
    switch (notifier.currentPhase) {
      case JobPhase.assign:
        return Column(
          children: [
            _buildAssignEmployeeList(context, notifier),
            10.verticalSpace,
            _buildAddEmployeeButton(context, notifier),
          ],
        );

      case JobPhase.initiated:
        return _buildBeforePhotos(context, notifier);

      case JobPhase.inProgress:
        return Column(
          children: [
            _buildAfterPhotos(context, notifier),
            15.verticalSpace,
            CustomTextField(
              controller: notifier.notesController,
              fieldName: "Work Notes",
              hintText: "Add progress notes",
              isMaxLines: true,
              onChanged: notifier.updateNotes,
            ),
          ],
        );

      case JobPhase.completed:
        return Column(children: [Text(getVendorStatusMessage(notifier.currentStatus ?? ""))]);
    }
  }

  String getVendorStatusMessage(String currentStatus) {
    if (currentStatus == AppStatus.workCompletedAwaitingConfirmation.name) {
      return "The work is completed. Waiting for the customer to verify it.";
    } else if (currentStatus == AppStatus.jobVerifiedPaymentPending.name) {
      return "Customer has verified the job. Waiting for payment initiation.";
    } else if (currentStatus == AppStatus.paymentCompleted.name) {
      return "Payment has been completed. You can now await customer feedback.";
    } else if (currentStatus == AppStatus.jobClosedDone.name) {
      return "This job is closed. All processes are completed.";
    } else {
      return "Status unknown.";
    }
  }

  Widget _buildAssignEmployeeList(BuildContext context, ProgressUpdateNotifier notifier) {
    if (notifier.assignedEmployees.isEmpty) {
      return const Text("No employees assigned yet.");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: notifier.assignedEmployees
          .map(
            (e) => Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: AppStyles.commonDecoration,
              child: ListTile(
                title: Text(e.name),
                subtitle: Text(e.phone),
                trailing: e.emiratesId != null
                    ? GestureDetector(
                        onTap: () => notifier.openImageViewer(context, e.emiratesId!),
                        child: const Text("View Emirates ID", style: TextStyle(color: Colors.blue)),
                      )
                    : null,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPersistentButtons(BuildContext context, ProgressUpdateNotifier notifier) {
    switch (notifier.currentPhase) {
      case JobPhase.assign:
        return CustomButton(
          text: "Assign Employees",
          onPressed: notifier.assignedEmployees.isNotEmpty
              ? () => notifier.assignEmployees(context)
              : null,
        );

      case JobPhase.initiated:
        return CustomButton(
          text: "Start Job",
          onPressed: notifier.photoPairs.isNotEmpty
              ? () async {
                  await notifier.submitJobCompletion(context);
                  await notifier.apiUpdateJobStatus(AppStatus.workStartedInProgress.id);
                  notifier.goToInProgress();
                }
              : null,
        );

      case JobPhase.inProgress:
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                text: "Hold",
                onPressed: notifier.notes.trim().isNotEmpty
                    ? () async {
                        // await notifier.apiUpdateJobStatus(AppStatus.hold.id);
                      }
                    : null,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: CustomButton(
                text: "Complete",
                onPressed: (notifier.notes.trim().isNotEmpty &&
                    notifier.photoPairs.any((pair) => pair.after != null))
                    ? () async {
                  await notifier.submitJobCompletion(context);
                  await notifier
                      .apiUpdateJobStatus(AppStatus.workCompletedAwaitingConfirmation.id)
                      .then((value) {
                    Navigator.pop(context);
                  });
                }
                    : null,
              ),
            ),
          ],
        );

      case JobPhase.completed:
        return CustomButton(
          text: "Submit Completion",
          onPressed: notifier.canSubmit ? () => notifier.submitJobCompletion(context) : null,
        );
    }
  }

  Widget _buildAddEmployeeButton(BuildContext context, ProgressUpdateNotifier notifier) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => AssignBottomSheet(
            onAdd: (name, phone, _, {emiratesId}) =>
                notifier.addEmployee(name, phone, emiratesId: emiratesId),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: DashedBorder(
          borderColor: AppColors.primary,
          strokeWidth: 1.5,
          dashWidth: 8,
          gap: 4,
          borderRadius: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plus, size: 20, color: AppColors.primary),
            10.horizontalSpace,
            Text("Add Employee", style: AppFonts.text14.semiBold.style),
          ],
        ),
      ),
    );
  }

  Widget buildCustomerInfo(BuildContext context, ProgressUpdateNotifier notifier) {
    final jobDetail = notifier.jobDetail;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(jobDetail.customerName ?? "Customer Name", style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text(jobDetail.serviceName ?? "Service Name", style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: jobDetail.phoneNumber ?? "---",
            bgColor: const Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: jobDetail.address ?? "---",
            bgColor: const Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text(
            "Requested Date: ${jobDetail.expectedDate?.formatFullDateTime() ?? "00/00/0000"}",
            style: AppFonts.text14.regular.style,
          ),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Priority: ', style: AppFonts.text14.regular.style),
                TextSpan(
                  text: jobDetail.priority ?? "None",
                  style: AppFonts.text14.regular.red.style,
                ),
              ],
            ),
          ),
          10.verticalSpace,
          if (jobDetail.fileContent != null)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.imageViewer,
                  arguments: jobDetail.fileContent,
                );
              },
              child: Image.memory(
                base64Decode(jobDetail.fileContent!),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "Job Description: ", style: AppFonts.text14.semiBold.style),
                TextSpan(
                  text: jobDetail.remarks ?? "Not Added",
                  style: AppFonts.text14.regular.style,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconLabelRow({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        10.horizontalSpace,
        Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
      ],
    );
  }

  Widget _buildBeforePhotos(BuildContext context, ProgressUpdateNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Before Photos", style: TextStyle(fontWeight: FontWeight.bold)),
        8.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifier.photoPairs.length < notifier.maxPhotos
              ? notifier.photoPairs.length + 1
              : notifier.maxPhotos,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (index == notifier.photoPairs.length &&
                notifier.photoPairs.length < notifier.maxPhotos) {
              return _buildAddPhotoButton(() => notifier.pickBeforePhoto());
            }
            final photo = notifier.photoPairs[index].before;
            return _buildPhotoTile(
              context: context,
              photo: photo,
              onRemove: () => notifier.removeBeforePhoto(index),
              onTap: () => notifier.openImageViewer(context, photo),
            );
          },
        ),
        if (notifier.photoPairs.length >= notifier.maxPhotos)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Maximum 5 photos allowed",
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildAfterPhotos(BuildContext context, ProgressUpdateNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("After Photos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        8.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifier.photoPairs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.8,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final pair = notifier.photoPairs[index];
            return _buildBeforeAfterCard(
              context,
              pair.before,
              pair.after,
              () => notifier.pickAfterPhoto(index),
              notifier,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPhotoTile({
    required BuildContext context,
    required File photo,
    required VoidCallback onRemove,
    required VoidCallback onTap,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onTap: onTap,
            child: Image.file(
              photo,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withOpacity(0.7),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white, size: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        height: 90,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: const Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBeforeAfterCard(
    BuildContext context,
    File before,
    File? after,
    VoidCallback onAddAfter,
    ProgressUpdateNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildImageWithLabel(
              "Before",
              before,
              () => notifier.openImageViewer(context, before),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_forward, size: 28, color: Colors.grey),
          ),
          Expanded(
            child: after != null
                ? _buildImageWithLabel(
                    "After",
                    after,
                    () => notifier.openImageViewer(context, after),
                  )
                : _buildAddPhotoButton(onAddAfter),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithLabel(String label, File image, VoidCallback onTap) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onTap: onTap,
            child: Image.file(image, height: ScreenSize.width < 380 ? 75 : 90,
                width: ScreenSize.width < 380 ? 75 : 90,
                fit: BoxFit.cover),
          ),
        ),
        5.verticalSpace,
        Text(label, style: AppFonts.text14.regular.style),
      ],
    );
  }
}
