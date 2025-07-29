import 'package:community_app/core/base/base_notifier.dart';
import 'package:flutter/material.dart';

class FeedbackNotifier extends ChangeNotifier {
  double vendorRating = 0;
  double serviceRating = 0;

  final TextEditingController vendorCommentController = TextEditingController();
  final TextEditingController serviceCommentController = TextEditingController();

  final emoticons = ['😫', '🙁', '😐', '🙂', '😄'];

  void updateVendorRating(double rating) {
    vendorRating = rating;
    notifyListeners();
  }

  void updateServiceRating(double rating) {
    serviceRating = rating;
    notifyListeners();
  }

  // Optionally, add submit methods
  void submitVendorFeedback() {
    final comment = vendorCommentController.text;
    final rating = vendorRating;
    // handle submission
  }

  void submitServiceFeedback() {
    final comment = serviceCommentController.text;
    final rating = serviceRating;
    // handle submission
  }

  @override
  void dispose() {
    vendorCommentController.dispose();
    serviceCommentController.dispose();
    super.dispose();
  }
}
