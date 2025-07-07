import 'package:community_app/core/base/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerNotifier extends BaseChangeNotifier {
  LatLng? _selectedPosition;
  String? _selectedPlaceName;

  final locationController = TextEditingController();

  // Optional address parts
  String? building;
  String? block;
  String? community;

  LatLng? get selectedPosition => _selectedPosition;
  String? get selectedPlaceName => _selectedPlaceName;

  /// Set position and place name
  Future<void> setPlaceDetails({
    required LatLng position,
    required String placeName,
  }) async {

    // Reverse geocode to get building/block/community
    await _fillAddressDetailsFromLatLng(position);
  }

  /// Reverse geocode to fill building, block, community
  Future<void> _fillAddressDetailsFromLatLng(LatLng position) async {
    try {
      _selectedPosition = position;

      final placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placeMarks.isNotEmpty) {
        final p = placeMarks.first;

        // Build your formatted address (street, block, city)
        final street = p.thoroughfare ?? '';
        final blockName = p.subLocality ?? '';
        final city = p.administrativeArea ?? '';

        final List<String> addressParts = [
          if (street.isNotEmpty) street,
          if (blockName.isNotEmpty) blockName,
          if (city.isNotEmpty) city,
        ];

        _selectedPlaceName = addressParts.join(", ");

        // Set building, block, community
        building = (p.subThoroughfare?.isNotEmpty == true) ? p.subThoroughfare : (p.name ?? '');
        block = blockName;
        community = p.locality ?? '';
      } else {
        building = null;
        block = null;
        community = null;
        _selectedPlaceName = null;
      }
    } catch (e) {
      building = null;
      block = null;
      community = null;
      _selectedPlaceName = null;
    }

    notifyListeners();
  }


  void clear() {
    _selectedPosition = null;
    _selectedPlaceName = null;
    building = null;
    block = null;
    community = null;
    notifyListeners();
  }
}
