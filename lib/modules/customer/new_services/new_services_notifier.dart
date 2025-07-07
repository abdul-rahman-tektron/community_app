import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewServicesNotifier extends BaseChangeNotifier {
  NewServicesNotifier();

  // Controllers
  final issueController = TextEditingController();
  final categoryController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final mobileController = TextEditingController();
  final expectedDateController = TextEditingController(); // For display

  // Fields
  String? _category;
  String? _priority;
  DateTime? _expectedDateTime;
  File? _uploadedPhoto;

  // Dropdown data
  final List<String> categoryDropdownData = [
    'Plumbing',
    'Painting',
    'Electrical',
    'Cleaning',
    'Carpentry',
    'Gardening',
    'Pest Control',
    'AC Repair',
    'Appliance Repair',
    'Security System'
  ];

  final List<String> priorityDropdownData = [
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];

  // Methods
  void setCategory(String? value) {
    category = value;
    notifyListeners();
  }

  void setPriority(String? value) {
    priority = value;
    notifyListeners();
  }

  Future<void> pickExpectedDateTime(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (time != null) {
        final selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        expectedDateTime = selected;
        expectedDateController.text = DateFormat('dd/MM/yyyy hh:mm a').format(selected);
        notifyListeners();
      }
    }
  }

  Future<void> uploadPhoto({bool fromCamera = false}) async {
    final file = await FileUploadHelper.pickImage(fromCamera: fromCamera);
    if (file != null) {
      uploadedPhoto = file;
      notifyListeners();
    }
  }

  Future<void> submitServiceRequest(BuildContext context) async {
    try {
      if (category == null || priority == null || issueController.text.isEmpty || mobileController.text.isEmpty || expectedDateTime == null) {
        ToastHelper.showError('Please complete all fields');
        return;
      }

      // Construct request model (create your own model if needed)
      // Submit to API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API

      ToastHelper.showSuccess('Service request submitted successfully');
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppRoutes.customerBottomBar);

    } catch (e, stackTrace) {
      ToastHelper.showError('An error occurred. Please try again.');
      print(e);
      print(stackTrace);
      notifyListeners();
    }
  }

  // Cleanup
  @override
  void dispose() {
    issueController.dispose();
    mobileController.dispose();
    expectedDateController.dispose();
    super.dispose();
  }

  // Getters & Setters
  String? get category => _category;
  set category(String? value) {
    if (_category != value) {
      _category = value;
      notifyListeners();
    }
  }

  String? get priority => _priority;
  set priority(String? value) {
    if (_priority != value) {
      _priority = value;
      notifyListeners();
    }
  }

  DateTime? get expectedDateTime => _expectedDateTime;
  set expectedDateTime(DateTime? value) {
    if (_expectedDateTime != value) {
      _expectedDateTime = value;
      notifyListeners();
    }
  }

  File? get uploadedPhoto => _uploadedPhoto;
  set uploadedPhoto(File? value) {
    if (_uploadedPhoto != value) {
      _uploadedPhoto = value;
      notifyListeners();
    }
  }
}
