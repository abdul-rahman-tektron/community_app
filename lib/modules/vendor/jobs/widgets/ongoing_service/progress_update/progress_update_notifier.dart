import 'dart:io';
import 'package:community_app/modules/common/image_viewer_screen.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
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

class ProgressUpdateNotifier extends ChangeNotifier {
  JobPhase currentPhase = JobPhase.assign;

  List<Map<String, String>> assignedEmployees = []; // name, phone
  String notes = '';
  List<PhotoPair> photoPairs = [];
  int maxPhotos = 5;

  TextEditingController notesController = TextEditingController();

  // Add employee
  void addEmployee(String name, String phone) {
    assignedEmployees.add({"name": name, "phone": phone});
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
}
