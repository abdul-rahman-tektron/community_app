import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/dropdown/priority_dropdown_response.dart';
import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/new_job_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewServicesNotifier extends BaseChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final remarksController = TextEditingController();
  final serviceController = TextEditingController();
  final priorityController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final expectedDateController = TextEditingController(); // For display

  // Fields
  String? _selectedService;
  String? _selectedServiceId;
  String? _selectedPriority;
  String? _selectedPriorityId;
  DateTime? _expectedDateTime;
  File? _uploadedFile;
  String? _uploadedFileName;

  bool siteVisitOption = false;

  // Dropdown data
  List<ServiceDropdownData> serviceDropdownData = [];

  final List<PriorityDropdownData> priorityDropdownData = [
    PriorityDropdownData(priorityId: 1, name: 'Low'),
    PriorityDropdownData(priorityId: 2, name: 'Medium'),
    PriorityDropdownData(priorityId: 3, name: 'High'),
    PriorityDropdownData(priorityId: 4, name: 'Emergency'),
  ];

  NewServicesNotifier() {
    initApi();
  }

  initApi() async {
    await loadUserData();
    await apiServiceDropdown();

    mobileNumberController.text = userData?.mobile ?? "Test";
  }

  // Methods
  void setCategory(ServiceDropdownData? value) {
    selectedService = value?.serviceName ?? "";
    selectedServiceId = value?.serviceId.toString() ?? "";
    notifyListeners();
  }

  void setPriority(PriorityDropdownData? value) {
    selectedPriority = value?.name ?? "";
    selectedPriorityId = value?.priorityId.toString() ?? "";
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
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));

      if (time != null) {
        final selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        expectedDateTime = selected;
        expectedDateController.text = DateFormat('dd/MM/yyyy hh:mm a').format(selected);
        notifyListeners();
      }
    }
  }

  void setSiteVisitOption(bool value) {
    siteVisitOption = value;
    notifyListeners();
  }

  Future<void> submitServiceRequest(BuildContext context) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (uploadedFile == null) {
        ToastHelper.showInfo('Please upload a file');
        return;
      }

      await apiCreateJob(context);
    } catch (e, stackTrace) {
      ToastHelper.showError('An error occurred. Please try again.');
      print(e);
      print(stackTrace);
      notifyListeners();
    }
  }

  //Service dropdown Api call
  Future<void> apiServiceDropdown() async {
    try {
      final result = await CommonRepository.instance.apiServiceDropdown();

      if (result is List<ServiceDropdownData>) {
        serviceDropdownData = result;
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiServiceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiServiceDropdown: $e");
    }
  }

  Future<void> apiCreateJob(BuildContext context) async {
    try {
      final request = CreateJobRequest(
        customerId: userData?.customerId ?? 0,
        jobId: int.parse(selectedServiceId ?? "0"),
        serviceId: int.parse(selectedServiceId ?? "0"),
        expectedDate: expectedDateController.text.toDateTimeFromDdMmYyyy(),
        contactNumber: mobileNumberController.text,
        priority: selectedPriority,
        remarks: remarksController.text,
        status: "Pending",
        createdBy: "Sana",
        active: true,
        siteVisitRequired: siteVisitOption,
        mediaList: [
          JobMediaList(
            type: "P",
            fileContent: await uploadedFile?.toBase64() ?? "",
            photoVideoType: "P",
            customerId: userData?.customerId ?? 0,
            jobId: 0,
            from: "C",
            identity: 0,
            inRefUID: 0,
            uid: 0,
            vendorId: 0,
          ),
        ],
      );

      final result = await CustomerJobsRepository.instance.apiNewJob(request);

      print("result");
      print(result);
      await _handleCreatedJobSuccess(result, context);
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedJobSuccess(dynamic result, BuildContext context) async {

    CommonResponse resultData = result as CommonResponse;

    Navigator.pushNamed(
      context,
      AppRoutes.topVendors,
      arguments: {
        'jobId': resultData.data,
        'serviceId': int.parse(selectedServiceId ?? "0"),
      },
    );
  }

  Future<void> pickImageOrVideo() async {
    final file = await FileUploadHelper.pickImageOrVideo();
    if (file != null) {
      uploadedFile = file;
      uploadedFileName = file.path.split('/').last;
    } else {
      uploadedFile = null;
      uploadedFileName = null;
    }
  }

  // Cleanup
  @override
  void dispose() {
    remarksController.dispose();
    mobileNumberController.dispose();
    expectedDateController.dispose();
    super.dispose();
  }

  // Getters & Setters
  String? get selectedService => _selectedService;

  set selectedService(String? value) {
    if (_selectedService != value) {
      _selectedService = value;
      notifyListeners();
    }
  }

  String? get selectedServiceId => _selectedServiceId;

  set selectedServiceId(String? value) {
    if (_selectedServiceId != value) {
      _selectedServiceId = value;
      notifyListeners();
    }
  }

  String? get selectedPriority => _selectedPriority;

  set selectedPriority(String? value) {
    if (_selectedPriority != value) {
      _selectedPriority = value;
      notifyListeners();
    }
  }

  String? get selectedPriorityId => _selectedPriorityId;

  set selectedPriorityId(String? value) {
    if (_selectedPriorityId != value) {
      _selectedPriorityId = value;
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

  File? get uploadedFile => _uploadedFile;

  set uploadedFile(File? value) {
    if (_uploadedFile != value) {
      _uploadedFile = value;
      notifyListeners();
    }
  }

  String? get uploadedFileName => _uploadedFileName;

  set uploadedFileName(String? value) {
    if (_uploadedFileName != value) {
      _uploadedFileName = value;
      notifyListeners();
    }
  }
}
