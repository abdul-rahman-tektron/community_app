import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignBottomSheet extends StatefulWidget {
  final void Function(String name, String phone) onAdd;

  const AssignBottomSheet({super.key, required this.onAdd});

  @override
  State<AssignBottomSheet> createState() => _AssignBottomSheetState();
}

class _AssignBottomSheetState extends State<AssignBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

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
            30.verticalSpace,
            CustomButton(
              text: "Add Employee",
              onPressed: () {
                if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
                  widget.onAdd(nameController.text.trim(), phoneController.text.trim());
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
        CustomTextField(controller: nameController, fieldName: "Employee Name", skipValidation: true),
        15.verticalSpace,
        CustomTextField(controller: phoneController, fieldName: "Employee Mobile Number", skipValidation: true),
      ],
    );
  }
}


