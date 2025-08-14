import 'dart:io';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/helpers/dashed_border_container.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_popup.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AssignBottomSheet extends StatefulWidget {
  final void Function(String name, String phone, {File? emiratesId}) onAdd;

  const AssignBottomSheet({super.key, required this.onAdd});

  @override
  State<AssignBottomSheet> createState() => _AssignBottomSheetState();
}

class _AssignBottomSheetState extends State<AssignBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  File? emiratesIdFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            10.verticalSpace,
            Text("Enter an employee to assign", style: AppFonts.text18.bold.style),
            20.verticalSpace,
            _employeeInfoField(),
            15.verticalSpace,
            _uploadEmiratesIdButton(context), // <-- NEW
            30.verticalSpace,
            CustomButton(
              text: "Add Employee",
              onPressed: () {
                if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
                  widget.onAdd(nameController.text.trim(), phoneController.text.trim(), emiratesId: emiratesIdFile);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter name & phone")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _employeeInfoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(controller: nameController,
            fieldName: "Employee Name",
            skipValidation: true),
        15.verticalSpace,
        CustomTextField(controller: phoneController,
            fieldName: "Employee Mobile Number",
            skipValidation: true,
            keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _uploadEmiratesIdButton(BuildContext context) {
    if (emiratesIdFile != null) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(emiratesIdFile!, height: 100, width: 100, fit: BoxFit.fill),
          ),
          TextButton(
            onPressed: () => setState(() => emiratesIdFile = null),
            child: Text("Remove Emirates ID", style: AppFonts.text14.regular.red.style,),
          ),
        ],
      );
    }

    // Only show button if no file is selected
    return GestureDetector(
      onTap: () {
        showImageSourceDialog(
          context,
              (file) => setState(() => emiratesIdFile = file),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundDecoration: DashedBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.upload, size: 20, color: AppColors.primary),
            10.horizontalSpace,
            Text("Upload Emirates ID (Optional)", style: AppFonts.text14.semiBold.style),
          ],
        ),
      ),
    );
  }
}
