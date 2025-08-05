import 'dart:io';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/progress_update/assign_bottom_sheet.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/progress_update/progress_update_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/dashed_border_container.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_search_dropdown.dart';
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
        builder: (context, notifier, _) => Scaffold(
          persistentFooterButtons: [_buildPersistentButtons(context, notifier)],
          appBar: CustomAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [buildCustomerInfo(context, notifier), 15.verticalSpace, _buildPhaseContent(context, notifier)],
            ),
          ),
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
      case JobPhase.inProgress:
        return CustomTextField(
          controller: notifier.notesController,
          fieldName: "Work Notes",
          hintText: "Add progress notes",
          isMaxLines: true,
          onChanged: notifier.updateNotes,
        );
      case JobPhase.completed:
        return Column(
          children: [
            _buildBeforePhotos(context, notifier),
            15.verticalSpace,
            _buildAfterPhotos(context, notifier),
            15.verticalSpace,
            _buildNotesField(notifier),
          ],
        );
    }
  }

  Widget _buildAssignEmployeeList(BuildContext context, ProgressUpdateNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...notifier.assignedEmployees.map(
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
        ),
      ],
    );
  }

  Widget _buildPersistentButtons(BuildContext context, ProgressUpdateNotifier notifier) {
    switch (notifier.currentPhase) {
      case JobPhase.assign:
        return CustomButton(
          text: "Assign",
          onPressed: notifier.assignedEmployees.isNotEmpty
              ? () =>
                    notifier.assignEmployees(context) // Pass real jobId & customerId
              : null,
        );
      case JobPhase.inProgress:
        return Row(
          children: [
            Expanded(
              child: CustomButton(text: "Hold", onPressed: notifier.notes.trim().isEmpty ? null : () {}),
            ),
            10.horizontalSpace,
            Expanded(
              child: CustomButton(text: "Complete", onPressed: notifier.goToCompleted),
            ),
          ],
        );
      case JobPhase.completed:
        return CustomButton(text: "Submit", onPressed: notifier.canSubmit ? () => _onSubmit(context, notifier) : null);
    }
  }

  Widget _buildAddEmployeeButton(BuildContext context, ProgressUpdateNotifier notifier) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => AssignBottomSheet(
            onAdd: (name, phone, {emiratesId}) => notifier.addEmployee(name, phone, emiratesId: emiratesId),
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

  Widget buildCustomerInfo(BuildContext context, ProgressUpdateNotifier progressUpdateNotifier) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ahmed Al Mazroui", style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text("Painting", style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: "05576263567",
            bgColor: Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: "Jumeirah, Villa 23",
            bgColor: Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text("Requested Date: 3 July 2025", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Priority: ', style: AppFonts.text14.regular.style),
                TextSpan(
                  text: 'Emergency',
                  style: AppFonts.text14.regular.red.style, // You can change the style here if needed
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Image.asset(AppImages.loginImage, height: 100, width: 100, fit: BoxFit.cover),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Job Description: ",
                  style: AppFonts.text14.semiBold.style, // Bold for "Remarks:"
                ),
                TextSpan(
                  text:
                      "We’re planning to repaint three bedrooms. One of them has old wallpaper that needs to be removed first. The other two just need surface preparation and a fresh coat of paint. We’d like durable, washable paint since we have young kids. Colors will be provided once the quote is finalized.",
                  style: AppFonts.text14.regular.style, // Regular for content
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
        _iconBox(icon: icon, bgColor: bgColor, iconColor: iconColor),
        10.horizontalSpace,
        Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
      ],
    );
  }

  Widget _iconBox({required IconData icon, required Color bgColor, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  // ---------------- BEFORE PHOTOS ----------------
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
            if (index == notifier.photoPairs.length && notifier.photoPairs.length < notifier.maxPhotos) {
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
            child: Text("Maximum 5 photos allowed", style: TextStyle(fontSize: 12, color: Colors.red)),
          ),
      ],
    );
  }

  // ---------------- AFTER PHOTOS ----------------
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

  // ---------------- REUSABLE PHOTO TILES ----------------
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
            child: Image.file(photo, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.error.withOpacity(0.7)),
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
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildImageWithLabel("Before", before, () => notifier.openImageViewer(context, before))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_forward, size: 28, color: Colors.grey),
          ),
          Expanded(
            child: after != null
                ? _buildImageWithLabel("After", after, () => notifier.openImageViewer(context, after))
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
            child: Image.file(image, height: 90, width: 90, fit: BoxFit.cover),
          ),
        ),
        5.verticalSpace,
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // ---------------- NOTES & SUBMIT ----------------
  Widget _buildNotesField(ProgressUpdateNotifier notifier) {
    return CustomTextField(
      controller: notifier.notesController,
      fieldName: "Notes",
      hintText: "Add any additional notes here",
      isMaxLines: true,
      onChanged: notifier.updateOverallNotes,
    );
  }

  Widget _buildSubmitButton(BuildContext context, ProgressUpdateNotifier notifier) {
    return CustomButton(
      onPressed: notifier.canSubmit ? () => _onSubmit(context, notifier) : null,
      text: "Submit Status",
    );
  }

  void _onSubmit(BuildContext context, ProgressUpdateNotifier notifier) {
    notifier.submitJobCompletion(context);
  }
}
