import 'dart:async';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/explore/explore_service_response.dart';
import 'package:community_app/core/remote/services/customer/customer_explore_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Models
class ServiceItem {
  final String service;
  final String vendorName;
  final double price;
  final double rating;

  ServiceItem({
    required this.service,
    required this.vendorName,
    required this.price,
    required this.rating,
  });
}

/// Sort Option Class
class SortOption {
  final SortType type;
  final bool ascending;

  const SortOption({
    required this.type,
    this.ascending = true,
  });

  // Convenience constructors (optional)
  static const priceLowToHigh = SortOption(type: SortType.price, ascending: true);
  static const priceHighToLow = SortOption(type: SortType.price, ascending: false);
  static const ratingHighToLow = SortOption(type: SortType.rating, ascending: false);
  static const ratingLowToHigh = SortOption(type: SortType.rating, ascending: true);
  static const bestDeals = SortOption(type: SortType.bestDeals);
}

class SortMeta {
  final String label;
  final IconData icon;
  final SortType type;
  final bool togglable;

  const SortMeta({
    required this.label,
    required this.icon,
    required this.type,
    this.togglable = false,
  });
}
 List<SortMeta> sortMetaList = [
  SortMeta(label: 'Price', icon: LucideIcons.dollarSign, type: SortType.price, togglable: true),
  SortMeta(label: 'Rating', icon: LucideIcons.star, type: SortType.rating, togglable: true),
  SortMeta(label: 'Best Deals', icon: LucideIcons.tag, type: SortType.bestDeals),
];

/// Notifier

class ExploreNotifier extends BaseChangeNotifier {
  final searchController = TextEditingController();
  final serviceController = TextEditingController();

  List<ExploreServiceData> exploreServices = [];
  SortOption? selectedSortOption;

  bool isLoading = false; // ✅ loader flag

  String selectedCategory = 'All';
  RangeValues? selectedPriceRange;
  DistanceFilter? selectedDistance;

  Timer? _debounce; // 👈 debounce timer

  ExploreNotifier({String? initialCategory}) {
    selectedCategory = initialCategory ?? 'All';
    initializeData();

    // Listen to search text with debounce
    searchController.addListener(() {
      _onSearchChanged();
    });
  }

  Future<void> initializeData() async {
    await fetchExploreServices();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchExploreServices(search: searchController.text);
    });
  }

  /// Call API with filters
  Future<void> fetchExploreServices({
    String? search,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await CustomerExploreRepository.instance.apiExploreService(
        search: search,
        sortBy: _mapSortToApi(selectedSortOption),
        // ✅ Only send if not full default range
        minPrice: (selectedPriceRange != null && selectedPriceRange!.start > 0)
            ? selectedPriceRange!.start.toInt()
            : null,
        maxPrice: (selectedPriceRange != null && selectedPriceRange!.end < 2000)
            ? selectedPriceRange!.end.toInt()
            : null,
        serviceId: selectedCategory != 'All'
            ? _mapCategoryToId(selectedCategory)
            : null,
      );

      if (response is ExploreServiceResponse && response.success == true) {
        exploreServices = response.data ?? [];
      } else {
        exploreServices = [];
      }
    } catch (e, stack) {
      print("Error fetching explore services: $e");
      print("Error fetching explore services: $stack");
      exploreServices = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  /// Update filters and fetch API
  void updateFilters({
    String? category,
    RangeValues? priceRange,
    DistanceFilter? distance,
  }) {
    if (category != null) selectedCategory = category;
    if (priceRange != null) selectedPriceRange = priceRange;
    if (distance != null) selectedDistance = distance;

    fetchExploreServices();
  }

  void clearFilters() {
    selectedCategory = 'All';
    selectedDistance = null;
    selectedPriceRange = null;
    selectedSortOption = null;
    serviceController.clear();
    searchController.clear();
    fetchExploreServices();
  }

  /// Updates sorting option and fetches API
  void updateSortOption(SortOption option) {
    final isSameType = selectedSortOption?.type == option.type;
    final isTogglable = _isSortTypeTogglable(option.type);

    if (isSameType && isTogglable) {
      selectedSortOption = SortOption(
        type: option.type,
        ascending: !(selectedSortOption?.ascending ?? true),
      );
    } else {
      selectedSortOption = SortOption(type: option.type, ascending: true);
    }

    fetchExploreServices();
  }

  /// Map SortOption -> API param
  String? _mapSortToApi(SortOption? option) {
    if (option == null) return null;
    switch (option.type) {
      case SortType.price:
        return option.ascending ? "price_asc" : "price_desc";
      case SortType.rating:
        return option.ascending ? "rating_asc" : "rating_desc";
      case SortType.bestDeals:
        return "bestDeals";
    }
  }

  /// Map category name -> serviceId (if your API requires IDs)
  int? _mapCategoryToId(String category) {
    switch (category) {
      case "AC Repair":
        return 1;
      case "Plumbing":
        return 2;
      case "Cleaning":
        return 3;
      case "Painting":
        return 4;
      case "Pest Control":
        return 5;
      default:
        return null;
    }
  }

  bool _isSortTypeTogglable(SortType type) {
    return type == SortType.price || type == SortType.rating;
  }

  List<String> get availableCategories => [
    'All',
    'AC Repair',
    'Plumbing',
    'Cleaning',
    'Painting',
    'Pest Control',
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    serviceController.dispose();
    super.dispose();
  }
}