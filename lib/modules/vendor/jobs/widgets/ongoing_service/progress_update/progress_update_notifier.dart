import 'dart:convert';
import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/job_completion_request.dart';
import 'package:community_app/core/model/vendor/assign_employee/assign_employee_request.dart';
import 'package:community_app/core/remote/services/vendor/vendor_jobs_repository.dart';
import 'package:community_app/modules/common/image_viewer_screen.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

enum JobProgressStatus {
  jobAssigned,
  employeeOnSite,
  jobInProgress,
  jobCompleted,
}

class PhotoPair {
  final File before;
  File? after;
  String? note;

  PhotoPair({required this.before, this.after, this.note});
}

class JobProgressDropdownData {
  final JobProgressStatus status;
  final String label;

  JobProgressDropdownData({required this.status, required this.label});
}

class AssignedEmployee {
  final String name;
  final String phone;
  final File? emiratesId;

  AssignedEmployee({required this.name, required this.phone, this.emiratesId});
}

class ProgressUpdateNotifier extends BaseChangeNotifier {
  JobPhase currentPhase = JobPhase.assign;

  List<AssignedEmployee> assignedEmployees = [];
  String notes = '';
  List<PhotoPair> photoPairs = [];
  int maxPhotos = 5;

  int? jobId;
  int? customerId;

  ProgressUpdateNotifier(this.jobId, this.customerId, status) {
    updatePhaseFromStatus(status);
  }

  TextEditingController notesController = TextEditingController();

  // Add employee
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

  void goToCompleted() {
    if (notes.trim().isEmpty) return; // enforce notes
    currentPhase = JobPhase.completed;
    notifyListeners();
  }

  bool get canSubmit {
    if (currentPhase == JobPhase.completed) {
      return photoPairs.every((p) => p.after != null) && notes.trim().isNotEmpty;
    }
    return true;
  }

  TextEditingController progressController = TextEditingController();

  List<JobProgressDropdownData> get progressStatusItems => [
    JobProgressDropdownData(status: JobProgressStatus.jobAssigned, label: "Job Assigned"),
    JobProgressDropdownData(status: JobProgressStatus.employeeOnSite, label: "Employee On Site"),
    JobProgressDropdownData(status: JobProgressStatus.jobInProgress, label: "In Progress"),
    JobProgressDropdownData(status: JobProgressStatus.jobCompleted, label: "Job Completed"),
  ];

  Future<void> assignEmployees(BuildContext context) async {
    if (assignedEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one employee")),
      );
      return;
    }

    // Await all base64 conversions with Future.wait
    final List<AssignEmployeeList> employeeList = await Future.wait(
      assignedEmployees.map((e) async {
        final base64Id = e.emiratesId != null ? await e.emiratesId!.toBase64() : null;
        return AssignEmployeeList(
          employeeName: e.name,
          employeePhoneNumber: e.phone,
          emiratesIdPhoto: base64Id,
        );
      }),
    );

    final request = AssignEmployeeRequest(
      jobId: jobId,
      customerId: 16,
      assignEmployeeList: employeeList,
    );

    try {
      final response = await VendorJobsRepository.instance.apiAssignEmployee(request);

      // Assuming response has a 'success' property (adjust as per your actual response)
      if (response != null && response is CommonResponse) {
        ToastHelper.showSuccess("Employees assigned successfully");
        goToInProgress(); // Move to next phase
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
      // Convert photoPairs File to base64 strings
      List<JobCompletionPhotoPair> encodedPhotoPairs = [];
      for (var pair in photoPairs) {
        final beforeBytes = await pair.before.readAsBytes();
        final beforeBase64 = base64Encode(beforeBytes);

        String? afterBase64;
        if (pair.after != null) {
          final afterBytes = await pair.after!.readAsBytes();
          afterBase64 = base64Encode(afterBytes);
        }

        encodedPhotoPairs.add(JobCompletionPhotoPair(
          beforePhoto: beforeBase64,
          afterPhoto: afterBase64,
        ));
      }

      final request = JobCompletionRequest(
        jobId: jobId,
        createdBy: "CurrentUser", // You should replace with actual current user info
        photoPairs: encodedPhotoPairs,
        notes: notes.trim(),
      );

      final response = await VendorJobsRepository.instance.apiJobCompletion(request);

      if (response is CommonResponse && (response.success ?? false)) {
        ToastHelper.showSuccess("Job completion submitted successfully.");
        // Optionally reset state or navigate away
      } else {
        final errorMessage = (response is CommonResponse)
            ? (response.message ?? "Failed to submit job completion.")
            : "Failed to submit job completion.";
        ToastHelper.showError(errorMessage);
      }
    } catch (e) {
      ToastHelper.showError("Error submitting job completion: $e");
    }
  }

  /// Pick Before Photo
  Future<void> pickBeforePhoto() async {
    final pickedFile = await FileUploadHelper.pickImage(); // <-- use helper
    if (pickedFile != null) {
      photoPairs.add(PhotoPair(before: pickedFile));
      notifyListeners();
    }
  }

  /// Pick After Photo
  Future<void> pickAfterPhoto(int index) async {
    final pickedFile = await FileUploadHelper.pickImage(); // <-- use helper
    if (pickedFile != null) {
      photoPairs[index].after = pickedFile;
      notifyListeners();
    }
  }

  void updateNote(int index, String note) {
    photoPairs[index].note = note;
    notifyListeners();
  }

  void updateOverallNotes(String value) {
    notes = value;
    notifyListeners();
  }

  void openImageViewer(BuildContext context, File image) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ImageViewerScreen(imageFile: image)),
    );
  }

  void removeBeforePhoto(int index) {
    photoPairs.removeAt(index);
    notifyListeners();
  }

  void updatePhaseFromStatus(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'initiated':
      case 'tracking': // assigned, so in progress phase
        currentPhase = JobPhase.assign;
        break;
      case 'employee on site':
      case 'in progress':
        currentPhase = JobPhase.inProgress;
        break;
      case 'completed':
        currentPhase = JobPhase.completed;
        break;
      default:
        currentPhase = JobPhase.assign;
        break;
    }
    notifyListeners();
  }

}
