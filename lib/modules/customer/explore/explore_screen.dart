import 'dart:convert';

import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/core/model/customer/explore/explore_service_response.dart';
import 'package:community_app/modules/customer/explore/explore_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_search_dropdown.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:community_app/utils/widgets/ratings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  final String? initialCategory;

  const ExploreScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExploreNotifier(initialCategory: initialCategory),
      child: Consumer<ExploreNotifier>(
        builder: (_, exploreNotifier, __) {
          return buildBody(context, exploreNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, ExploreNotifier exploreNotifier) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: exploreNotifier.searchController,
                      fieldName: "Search",
                      prefix: Icon(LucideIcons.search),
                      skipValidation: true,
                    ),
                  ),
                  15.horizontalSpace,
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => buildFilterSheet(context, exploreNotifier),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(LucideIcons.listFilter, color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Builder(
                  builder: (_) {
                    if (exploreNotifier.isLoading) {
                      // ✅ Loader
                      return const Center(child: LottieLoader());
                    } else if (exploreNotifier.exploreServices.isEmpty) {
                      // ✅ Empty state text
                      return const Center(
                        child: Text(
                          "No jobs found",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      );
                    } else {
                      // ✅ Services Grid
                      return GridView.builder(
                        itemCount: exploreNotifier.exploreServices.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final service = exploreNotifier.exploreServices[index];
                          return _buildServiceCard(context, service);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterSheet(BuildContext context, ExploreNotifier exploreNotifier) {
    // Local state for filters UI until applied
    RangeValues selectedPriceRange =
        exploreNotifier.selectedPriceRange ?? const RangeValues(0, 2000);
    DistanceFilter? selectedDistance = exploreNotifier.selectedDistance;
    SortOption? localSortOption = exploreNotifier.selectedSortOption;

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heading
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.funnel),
                      SizedBox(width: 10),
                      Text("Filter Services", style: AppFonts.text16.semiBold.style),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Sort By Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text("Sort By", style: AppFonts.text14.medium.style),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // padding around scroll content
                        child: Row(
                          children: sortMetaList.map((meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10), // space between chips
                              child: meta.togglable
                                  ? _sortToggleChip(
                                      context: context,
                                      label: meta.label,
                                      icon: meta.icon,
                                      sortType: meta.type,
                                      currentSort: localSortOption,
                                      onChanged: (newSort) {
                                        setState(() {
                                          localSortOption = newSort;
                                        });
                                      },
                                    )
                                  : _sortSimpleChip(
                                      context: context,
                                      label: meta.label,
                                      icon: meta.icon,
                                      sortType: meta.type,
                                      currentSort: localSortOption,
                                      onChanged: (newSort) {
                                        setState(() {
                                          localSortOption = newSort;
                                        });
                                      },
                                    ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Category Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomSearchDropdown<ServiceDropdownData>(
                    fieldName: "Category",
                    hintText: "Select Category",
                    controller: exploreNotifier.serviceController,
                    items: exploreNotifier.serviceDropdownData,
                    currentLang: 'en',
                    itemLabel: (item, lang) => item.serviceName ?? "",
                    onSelected: (ServiceDropdownData? menu) {
                      setState(() {
                        exploreNotifier.selectedCategory = menu?.serviceName ?? 'All';
                        exploreNotifier.selectedCategoryId = menu?.serviceId ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Price Range Slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Price Range: AED ${selectedPriceRange.start.toInt()} - ${selectedPriceRange.end.toInt()}",
                        style: AppFonts.text14.medium.style,
                      ),
                    ),
                    RangeSlider(
                      values: selectedPriceRange,
                      min: 0,
                      max: 2000,
                      divisions: 20,
                      activeColor: AppColors.primary,
                      inactiveColor: const Color(0xffECECEC),
                      labels: RangeLabels(
                        'AED ${selectedPriceRange.start.toInt()}',
                        'AED ${selectedPriceRange.end.toInt()}',
                      ),
                      onChanged: (values) => setState(() {
                        selectedPriceRange = values;
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Distance Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    children: DistanceFilter.values.map((filter) {
                      final text = {
                        DistanceFilter.near1Km: 'Near 1km',
                        DistanceFilter.near5Km: 'Near 5km',
                        DistanceFilter.near10Km: 'Near 10km',
                      }[filter]!;

                      final isSelected = selectedDistance == filter;

                      return ChoiceChip(
                        label: Text(text),
                        selected: isSelected,
                        onSelected: (_) => setState(() {
                          selectedDistance = isSelected ? null : filter;
                        }),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.white,
                        checkmarkColor: AppColors.white,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),

                // Apply & Clear Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          height: 40,
                          onPressed: () {
                            // Update filters & sorting on notifier
                            exploreNotifier.updateFilters(
                              category: exploreNotifier.selectedCategory,
                              priceRange: selectedPriceRange,
                              distance: selectedDistance,
                            );
                            if (localSortOption != null) {
                              exploreNotifier.updateSortOption(localSortOption!);
                            }
                            // Sorting is already updated on chip tap in this UI
                            Navigator.pop(context);
                          },
                          text: "Apply Filter",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          height: 40,
                          backgroundColor: AppColors.white,
                          borderColor: AppColors.primary,
                          textStyle: AppFonts.text14.regular.style,
                          onPressed: () {
                            exploreNotifier.clearFilters();
                            Navigator.pop(context);
                          },
                          text: "Clear",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sortToggleChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required SortType sortType,
    required SortOption? currentSort,
    required ValueChanged<SortOption> onChanged,
  }) {
    final isSelected = currentSort?.type == sortType;
    final ascending = currentSort?.ascending ?? true;
    final arrow = ascending ? Icons.arrow_upward : Icons.arrow_downward;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
          const SizedBox(width: 4),
          Icon(arrow, size: 14, color: isSelected ? Colors.white : Colors.black),
        ],
      ),
      showCheckmark: false,
      selected: isSelected,
      onSelected: (_) {
        if (isSelected) {
          onChanged(SortOption(type: sortType, ascending: !ascending));
        } else {
          onChanged(SortOption(type: sortType, ascending: true));
        }
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      checkmarkColor: Colors.transparent,
    );
  }

  Widget _sortSimpleChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required SortType sortType,
    required SortOption? currentSort,
    required ValueChanged<SortOption> onChanged,
  }) {
    final isSelected = currentSort?.type == sortType;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
        ],
      ),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (_) {
        onChanged(SortOption(type: sortType));
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      checkmarkColor: Colors.transparent,
    );
  }

  Widget _buildServiceCard(BuildContext context, ExploreServiceData service) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context, AppRoutes.serviceDetails, arguments: {
          "serviceId": service.serviceId ?? 0,
          "vendorId": service.vendorId ?? 0,
        });
      },
      child: Container(
        decoration: AppStyles.commonDecoration,
        child: Column(
          children: [
            /// Image - 53% height
            Expanded(
              flex: 53,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: SizedBox.expand(
                  child: Image.memory(base64Decode(service.serviceImage ?? ""), fit: BoxFit.cover),
                ),
              ),
            ),

            /// Content - 47% height
            Expanded(
              flex: 47,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceName ?? "",
                      style: AppFonts.text14.semiBold.style.copyWith(
                        fontSize: ScreenSize.width < 380 ? 11 : 14,
                      ),
                      maxLines: 1,
                    ),
                    4.verticalSpace,
                    Text(
                      service.vendorName ?? "",
                      style: AppFonts.text14.medium.style.copyWith(
                        fontSize: ScreenSize.width < 380 ? 11 : 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        RatingsHelper(
                          rating: service.rating?.toDouble() ?? 0.0,
                          size: ScreenSize.width < 380 ? 15 : 20,
                        ),
                        4.horizontalSpace,
                        Text(
                          "(${service.reviewCount?.toInt() ?? 0})",
                          style: AppFonts.text12.regular.style,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
