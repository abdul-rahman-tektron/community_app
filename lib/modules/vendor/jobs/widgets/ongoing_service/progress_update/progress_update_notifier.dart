import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/job_completion_details_response.dart';
import 'package:community_app/core/model/customer/job/job_completion_request.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/model/vendor/assign_employee/assign_employee_request.dart';
import 'package:community_app/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_jobs_repository.dart';
import 'package:community_app/modules/common/image_viewer_screen.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class PhotoPair {
  final File before;
  File? after;
  String? note;

  PhotoPair({required this.before, this.after, this.note});
}

class AssignedEmployee {
  final String name;
  final String phone;
  final File? emiratesId;

  AssignedEmployee({required this.name, required this.phone, this.emiratesId});
}

class ProgressUpdateNotifier extends BaseChangeNotifier {
  JobPhase currentPhase = JobPhase.initiated;
  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();

  List<AssignedEmployee> assignedEmployees = [];
  String notes = '';
  List<PhotoPair> photoPairs = [];
  int maxPhotos = 5;

  int? jobId;
  int? customerId;
  String? currentStatus;

  ProgressUpdateNotifier(this.jobId, this.customerId, this.currentStatus) {
    runWithLoadingVoid(() => initializeData());
  }

  Future<void> initializeData() async {
    await apiJobInfoDetail();
    updatePhaseFromStatus(AppStatus.fromName(currentStatus ?? ""));
    if(currentPhase == JobPhase.inProgress || currentPhase == JobPhase.completed) await loadJobCompletionDetails();
  }

  TextEditingController notesController = TextEditingController();

  void addEmployee(String name, String phone, {File? emiratesId}) {
    assignedEmployees.add(AssignedEmployee(name: name, phone: phone, emiratesId: emiratesId));
    notifyListeners();
  }

  void updateNotes(String value) {
    notes = value;
    notifyListeners();
  }

  void goToInProgress() {
    currentPhase = JobPhase.inProgress;
    notifyListeners();
  }

  void goToInitiated() {
    currentPhase = JobPhase.initiated;
    notifyListeners();
  }

  bool get canSubmit =>
      currentPhase == JobPhase.completed
          ? photoPairs.every((p) => p.after != null) && notes.trim().isNotEmpty
          : true;

  Future<void> apiJobInfoDetail() async {
    try {
      final result = await VendorDashboardRepository.instance.apiJobInfoDetail(jobId?.toString() ?? "0");
      if (result is JobInfoDetailResponse) jobDetail = result;
    } catch (e) {
      debugPrint("Error in apiJobInfoDetail: $e");
    }
  }

  Future<void> apiUpdateJobStatus(int? statusId) async {
    if (statusId == null) return;
    try {
      notifyListeners();
      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        currentStatus = AppStatus.fromId(statusId)?.name;
        updatePhaseFromStatus(AppStatus.fromId(statusId));
        ToastHelper.showSuccess("Status updated to: ${AppStatus.fromName(currentStatus ?? "")?.name ?? ""}");
      }
    } catch (e) {
      ToastHelper.showError('Error updating status: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> assignEmployees(BuildContext context) async {
    if (assignedEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add at least one employee")));
      return;
    }

    final List<AssignEmployeeList> employeeList = await Future.wait(
      assignedEmployees.map((e) async {
        final base64Id = e.emiratesId != null ? await e.emiratesId!.toBase64() : null;
        return AssignEmployeeList(employeeName: e.name, employeePhoneNumber: e.phone, emiratesIdPhoto: base64Id);
      }),
    );

    final request = AssignEmployeeRequest(jobId: jobId, customerId: customerId ?? 0, assignEmployeeList: employeeList);

    try {
      final response = await VendorJobsRepository.instance.apiAssignEmployee(request);

      if (response is CommonResponse && response.success == true) {
        await apiUpdateJobStatus(AppStatus.employeeAssigned.id);
        ToastHelper.showSuccess("Employees assigned successfully");
        goToInitiated();
      } else {
        ToastHelper.showError("Something went wrong, please try again.");
      }
    } catch (e) {
      ToastHelper.showError("Failed to assign employees: $e");
    }
  }

  Future<void> submitJobCompletion(BuildContext context) async {
    if (!canSubmit) {
      ToastHelper.showError("Please complete all required fields and photos.");
      return;
    }

    try {
      List<JobCompletionPhotoPair> encodedPhotoPairs = [];

      for (var pair in photoPairs) {
        final beforeBase64 = base64Encode(await pair.before.readAsBytes());

        // If the job is still initiated, send empty afterPhoto
        final afterBase64 = currentPhase == JobPhase.initiated
            ? "" // empty string
            : pair.after != null
            ? base64Encode(await pair.after!.readAsBytes())
            : null; // optional for safety

        encodedPhotoPairs.add(JobCompletionPhotoPair(
          beforePhoto: beforeBase64,
          afterPhoto: afterBase64,
        ));
      }

      final request = JobCompletionRequest(
        jobId: jobId,
        createdBy: "CurrentUser",
        photoPairs: encodedPhotoPairs,
        notes: notes.trim(),
      );

      final response = await VendorJobsRepository.instance.apiJobCompletion(request);

      if (response is CommonResponse && (response.success ?? false)) {
        ToastHelper.showSuccess("Job completion submitted successfully.");
      } else {
        ToastHelper.showError(response is CommonResponse ? response.message ?? "" : "Failed to submit job completion.");
      }
    } catch (e) {
      ToastHelper.showError("Error submitting job completion: $e");
    }
  }

  Future<void> loadJobCompletionDetails() async {
    try {
      final response = await CustomerJobsRepository.instance
          .apiJobCompletionDetails(jobId.toString());

      if (response is JobCompletionDetailsResponse) {
        photoPairs.clear();
        if (response.photos != null) {
          int index = 0; // unique index for file names
          for (var photo in response.photos!) {
            // Before photo
            final beforeFile = await FileUploadHelper.base64ToFile(
              photo.beforePhotoUrl!,
              fileName: "before_$index.jpg",
            );

            // After photo (may be null)
            File? afterFile;
            if (photo.afterPhotoUrl != null && photo.afterPhotoUrl!.isNotEmpty) {
              afterFile = await FileUploadHelper.base64ToFile(
                photo.afterPhotoUrl!,
                fileName: "after_$index.jpg",
              );
            }

            photoPairs.add(PhotoPair(before: beforeFile, after: afterFile));
            index++;
          }
        }

        notes = response.notes ?? "";
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading job completion details: $e");
    }
  }

  Future<void> pickBeforePhoto() async {
    final pickedFile = await FileUploadHelper.pickImage();
    if (pickedFile != null) {
      photoPairs.add(PhotoPair(before: pickedFile));
      notifyListeners();
    }
  }

  Future<void> pickAfterPhoto(int index) async {
    final pickedFile = await FileUploadHelper.pickImage();
    if (pickedFile != null) {
      photoPairs[index].after = pickedFile;
      notifyListeners();
    }
  }

  void updatePhaseFromStatus(AppStatusData? status) {
    if (status == null) {
      currentPhase = JobPhase.assign;
    } else if (status.id < 9) {
      currentPhase = JobPhase.assign;
    } else if (status.id < 10) {
      currentPhase = JobPhase.initiated;
    } else if (status.id < 12) {
      currentPhase = JobPhase.inProgress;
    } else if (status.id < 17) {
      currentPhase = JobPhase.completed;
    } else {
      currentPhase = JobPhase.assign;
    }
    notifyListeners();
  }

  void openImageViewer(BuildContext context, File image) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ImageViewerScreen(imageFile: image)),
    );
  }

  void removeBeforePhoto(int index) {
    if (index >= 0 && index < photoPairs.length) {
      photoPairs.removeAt(index);
      notifyListeners();
    }
  }

  JobInfoDetailResponse get jobDetail => _jobDetail;
  set jobDetail(JobInfoDetailResponse value) {
    if (_jobDetail == value) return;
    _jobDetail = value;
    notifyListeners();
  }

  void updateOverallNotes(String value) {
    notes = value;
    notifyListeners();
  }
}

