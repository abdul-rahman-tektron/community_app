import 'package:community_app/core/base/base_notifier.dart';
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

  SortOption? selectedSortOption;

  final List<ServiceItem> _allServices = [
    ServiceItem(service: "AC Repair", vendorName: "Farnek LLC", price: 120, rating: 4.5),
    ServiceItem(service: "Plumbing", vendorName: "AlNajma AlFareeda LLC And Co", price: 80, rating: 4.2),
    ServiceItem(service: "Cleaning", vendorName: "Wasl LLC", price: 60, rating: 4.7),
    ServiceItem(service: "Painting", vendorName: "IMDAAD LLC", price: 150, rating: 4.0),
    ServiceItem(service: "Pest Control", vendorName: "Emrill Services", price: 100, rating: 4.3),
  ];

  List<ServiceItem> filteredServices = [];

  String selectedCategory = 'All';
  RangeValues selectedPriceRange = const RangeValues(0, 200);
  DistanceFilter? selectedDistance;


  ExploreNotifier({String? initialCategory}) {
    selectedCategory = initialCategory ?? 'All';
    filteredServices = List.from(_allServices);
    searchController.addListener(_filterServices);

    // Trigger filter once with initial category
    _filterServices();
  }

  void _filterServices() {
    final query = searchController.text.toLowerCase();

    filteredServices = _allServices.where((service) {
      final matchQuery = service.service.toLowerCase().contains(query);
      final matchPrice = service.price >= selectedPriceRange.start &&
          service.price <= selectedPriceRange.end;
      final matchCategory = selectedCategory == 'All' || service.service == selectedCategory;
      // Note: Distance filter can be implemented here when ready
      return matchQuery && matchPrice && matchCategory;
    }).toList();

    // Apply sorting
    if (selectedSortOption != null) {
      switch (selectedSortOption!.type) {
        case SortType.price:
          filteredServices.sort((a, b) => selectedSortOption!.ascending
              ? a.price.compareTo(b.price)
              : b.price.compareTo(a.price));
          break;
        case SortType.rating:
          filteredServices.sort((a, b) => selectedSortOption!.ascending
              ? a.rating.compareTo(b.rating)
              : b.rating.compareTo(a.rating));
          break;
        case SortType.bestDeals:
          filteredServices.sort((a, b) =>
              ((b.rating / b.price) * 100).compareTo((a.rating / a.price) * 100));
          break;
      }
    }

    notifyListeners();
  }

  void updateFilters({
    String? category,
    RangeValues? priceRange,
    DistanceFilter? distance,
  }) {
    if (category != null) selectedCategory = category;
    if (priceRange != null) selectedPriceRange = priceRange;
    if (distance != null) selectedDistance = distance;
    _filterServices();
  }

  void clearFilters() {
    selectedCategory = 'All';
    selectedDistance = null;
    selectedPriceRange = const RangeValues(0, 200);
    selectedSortOption = null;
    serviceController.clear();
    searchController.clear();
    _filterServices();
  }

  /// Updates the sorting option.
  /// Toggles ascending if the same sort type is selected again.
  /// Otherwise, sets ascending to true for a new type.
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

    _filterServices();
  }

  bool _isSortTypeTogglable(SortType type) {
    // If you have the sortMetaList in scope, else hardcode:
    switch (type) {
      case SortType.price:
      case SortType.rating:
        return true;
      case SortType.bestDeals:
      default:
        return false;
    }
  }

  List<String> get availableCategories =>
      ['All', ..._allServices.map((e) => e.service).toSet()];
}
