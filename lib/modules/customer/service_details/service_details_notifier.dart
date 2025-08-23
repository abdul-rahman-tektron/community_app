import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/explore/service_detail_response.dart';
import 'package:community_app/core/remote/services/customer/customer_explore_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class ServiceDetailsNotifier extends BaseChangeNotifier {
  // Description

  String? serviceId;
  String? vendorId;

  ServiceDetailData? serviceDetail;

  bool _isLoading = true;

  final double _rating = 4.2;

  ServiceDetailsNotifier({
    this.serviceId,
  }) {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await apiServiceDetails();
  }


  bool _showFullDescription = false;
  bool get showFullDescription => _showFullDescription;

  Future<void> apiServiceDetails() async {
    try {
      final result = await CustomerExploreRepository.instance.apiServiceDetails(
        userData?.customerId.toString() ?? "0",
        serviceId.toString(),
      );

      if (result is ServiceDetailResponse) {
        serviceDetail = result.data;
        notifyListeners();
      }

    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleDescription() {
    _showFullDescription = !_showFullDescription;
    notifyListeners();
  }

  final String _description =
      "This is a premium cleaning service designed for homes and offices. Our professionals use eco-friendly materials and provide top-rated results. Schedule flexible appointments based on your availability and enjoy seamless service. We guarantee customer satisfaction.";

  String get description => _description;

  final List<String> imageUrls = [
    'https://www.southernliving.com/thmb/yT3SGvAjaMSpt6Vwt62nZLeqJkY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-1327576000-fff516a82eff488db59e9b22db013034.jpg',
    'https://usercontent.one/wp/www.cleaningcompany.ae/wp-content/uploads/2025/05/deep-cleaning.webp?media=1750514066',
    'https://plus.unsplash.com/premium_photo-1663011218145-c1d0c3ba3542?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y2xlYW5pbmd8ZW58MHx8MHx8fDA%3D',
  ];

  final PageController pageController = PageController();
  int currentPage = 0;

  void updatePage(int index) {
    currentPage = index % imageUrls.length;
    notifyListeners();
  }

  void startAutoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (pageController.hasClients) {
        int nextPage = pageController.page!.toInt() + 1;
        pageController.jumpToPage(nextPage);
      }
      return true;
    });
  }

  // Reviews (mock data)
  final List<ReviewModel> _reviews = [
    ReviewModel(
      name: "John Doe",
      profileUrl: "", // You can add a URL or leave empty for placeholder
      rating: 5,
      comment: "Excellent service, punctual and professional.",
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    ReviewModel(
      name: "Aisha",
      profileUrl: "",
      rating: 4,
      comment: "Very good experience. Will book again.",
      createdAt: DateTime.now().subtract(Duration(days: 5)),
    ),
    ReviewModel(
      name: "Mohammed bin Abdullah Al Thani", // Very long name
      profileUrl: "",
      rating: 3,
      comment: "Decent service but there is room for improvement. Communication could be better.",
      createdAt: DateTime.now().subtract(Duration(days: 8)),
    ),
    ReviewModel(
      name: "Lina",
      profileUrl: "",
      rating: 2,
      comment: "Honestly, I had a mixed experience. While the staff was friendly, the service took too long and some of my requests were not fulfilled. Could be better if they improve responsiveness and quality consistency.",
      createdAt: DateTime.now().subtract(Duration(days: 12)),
    ),
  ];

  List<ReviewModel> get reviews => _reviews;

  double get rating => _rating;

  // Feedback comment
  final TextEditingController feedbackController = TextEditingController();

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }
}

class ReviewModel {
  final String name;
  final String profileUrl;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.name,
    required this.profileUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  String get daysAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays == 0) return "Today";
    if (diff.inDays == 1) return "1 day ago";
    return "${diff.inDays} days ago";
  }
}
