import 'dart:async';

import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:Xception/core/model/customer/explore/explore_service_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_explore_repository.dart';
import 'package:Xception/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
  final scrollController = ScrollController();

  List<ExploreServiceData> exploreServices = [];
  List<ServiceDropdownData> serviceDropdownData = [];
  SortOption? selectedSortOption;

  String? selectedCategory;
  int? selectedCategoryId;
  RangeValues? selectedPriceRange;
  DistanceFilter? selectedDistance;

  Timer? _debounce;

  // ✅ Pagination state
  int _pageNumber = 1;
  final int _pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  ExploreNotifier({String? initialCategory}) {
    selectedCategoryId = int.tryParse(initialCategory ?? "");
    initializeData();

    searchController.addListener(_onSearchChanged);

    // ✅ Listen scroll for lazy load
    scrollController.addListener(_onScroll);
  }

  Future<void> initializeData() async {
    await Future.wait([apiServiceDropdown(), fetchExploreServices(reset: true)]);
  }

  void _onScroll() {
    if (!hasMore || isLoadingMore || isLoading) return;

    // load when user reaches near bottom
    final trigger = scrollController.position.maxScrollExtent - 200;
    if (scrollController.position.pixels >= trigger) {
      fetchExploreServices(loadMore: true);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchExploreServices(
        reset: true,
        search: searchController.text.trim().isEmpty ? null : searchController.text.trim(),
      );
    });
  }

  Future<void> fetchExploreServices({
    String? search,
    bool reset = false,
    bool loadMore = false,
  }) async {
    try {
      // ✅ decide page
      if (reset) {
        _pageNumber = 1;
        hasMore = true;
        exploreServices.clear();
        isLoading = true;
        notifyListeners();
      } else if (loadMore) {
        if (!hasMore) return;
        isLoadingMore = true;
        notifyListeners();
      } else {
        // normal fetch (no reset, no loadMore)
        _pageNumber = 1;
        hasMore = true;
        exploreServices.clear();
        isLoading = true;
        notifyListeners();
      }

      final response = await CustomerExploreRepository.instance.apiExploreService(
        search: search,
        pageNumber: _pageNumber,
        pageSize: _pageSize,
        sortBy: _mapSortToApi(selectedSortOption),
        minPrice: (selectedPriceRange != null && selectedPriceRange!.start > 0)
            ? selectedPriceRange!.start.toInt()
            : null,
        maxPrice: (selectedPriceRange != null && selectedPriceRange!.end < 2000)
            ? selectedPriceRange!.end.toInt()
            : null,
        serviceId: selectedCategory != 'All' ? selectedCategoryId : null,
      );

      if (response is ExploreServiceResponse && response.success == true) {
        final newItems = response.data ?? [];

        // ✅ append for loadMore, replace for reset already cleared
        exploreServices.addAll(newItems);

        // ✅ if API returned less than pageSize -> no more pages
        hasMore = newItems.length == _pageSize;

        if (hasMore) _pageNumber++; // ✅ next page
      } else {
        hasMore = false;
      }
    } catch (e, stack) {
      debugPrint("Error fetching explore jobs: $e");
      debugPrint("$stack");
      hasMore = false;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void updateFilters({
    String? category,
    RangeValues? priceRange,
    DistanceFilter? distance,
  }) {
    if (category != null) selectedCategory = category;
    if (priceRange != null) selectedPriceRange = priceRange;
    if (distance != null) selectedDistance = distance;

    fetchExploreServices(reset: true, search: searchController.text.trim().isEmpty ? null : searchController.text.trim());
  }

  void clearFilters() {
    selectedCategory = 'All';
    selectedDistance = null;
    selectedPriceRange = null;
    selectedSortOption = null;
    serviceController.clear();
    searchController.clear();
    fetchExploreServices(reset: true);
  }

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

    fetchExploreServices(reset: true, search: searchController.text.trim().isEmpty ? null : searchController.text.trim());
  }

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

  bool _isSortTypeTogglable(SortType type) => type == SortType.price || type == SortType.rating;

  Future<void> apiServiceDropdown() async {
    try {
      final result = await CommonRepository.instance.apiServiceDropdown();
      if (result is List<ServiceDropdownData>) {
        serviceDropdownData = result;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error in apiServiceDropdown: $e");
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    serviceController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
