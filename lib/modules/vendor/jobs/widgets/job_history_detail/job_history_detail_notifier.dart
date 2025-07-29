import 'package:community_app/core/base/base_notifier.dart';
import 'dart:io';

import 'package:community_app/res/images.dart';

class JobHistoryDetailNotifier extends BaseChangeNotifier {
  String customerName = "";
  String serviceName = "";
  String phone = "";
  String location = "";
  String requestedDate = "";
  String priority = "";
  String jobDescription = "";
  double totalAmount = 0;
  List<ImagePair> imagePairs = [];
  String notes = "";

  final int jobId;
  JobHistoryDetailNotifier(this.jobId) {
    loadJobDetail();
  }

  Future<void> loadJobDetail() async {
    // Simulated API delay

    customerName = "Ahmed Al Mazroui";
    serviceName = "Painting";
    phone = "05576263567";
    location = "Jumeirah, Villa 23";
    requestedDate = "3 July 2025";
    priority = "Emergency";
    jobDescription =
    "Repaint three bedrooms. Remove old wallpaper in one room. Surface prep & apply two coats of washable paint.";
    totalAmount = 1250.00;
    notes =
    "The painting was completed as requested. Applied 2 coats of paint and replaced damaged wallpaper.";
    imagePairs = [
      ImagePair(
        before:
        "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
      ImagePair(
        before:
        "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
      ImagePair(
        before:
        "https://jureursicphotography.com/wp-content/uploads/2020/10/2020_02_21_Sephora-Favurite-Box5247.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
      ImagePair(
        before:
        "https://jureursicphotography.com/wp-content/uploads/2020/10/2020_02_21_Sephora-Favurite-Box5247.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
    ];
    notifyListeners();
  }
}


class ImagePair {
  final String before;
  final String after;
  final bool isVideo;

  ImagePair({
    required this.before,
    required this.after,
    this.isVideo = false,
  });
}