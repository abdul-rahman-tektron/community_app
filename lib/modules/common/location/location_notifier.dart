import 'package:Xception/core/base/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// Notifier controlling the map, pin, and reverse-geocoded labels.
class LocationPickerNotifier extends BaseChangeNotifier {
  GoogleMapController? _mapController;

  LatLng? _selectedPosition;
  String? _selectedPlaceName;

  final locationController = TextEditingController();

  String? building;
  String? block;
  String? community;

  LatLng? get selectedPosition => _selectedPosition;
  String? get selectedPlaceName => _selectedPlaceName;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Sets the selected position and triggers reverse-geocoding + camera move.
  Future<void> setPlaceDetails({
    required LatLng position,
    required String placeName,
  }) async {
    _selectedPosition = position;
    _selectedPlaceName = placeName; // initial (will be refined by reverse geocode)
    await _reverseGeocode(position);
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
    notifyListeners();
  }

  /// Reverse geocoding to fill address pieces.
  Future<void> _reverseGeocode(LatLng position) async {
    try {
      final list = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (list.isNotEmpty) {
        final p = list.first;

        final street = p.thoroughfare ?? '';
        final blockName = p.subLocality ?? '';
        final city = p.administrativeArea ?? '';

        final parts = <String>[
          if (street.isNotEmpty) street,
          if (blockName.isNotEmpty) blockName,
          if (city.isNotEmpty) city,
        ];

        _selectedPlaceName = parts.isNotEmpty ? parts.join(', ') : _selectedPlaceName;

        building = (p.subThoroughfare?.isNotEmpty == true)
            ? p.subThoroughfare
            : (p.name ?? '');
        block = blockName;
        community = p.locality ?? '';
      } else {
        building = null;
        block = null;
        community = null;
      }
    } catch (e) {
      // Silent fail → keep minimal info; clear fine-grained fields
      building = null;
      block = null;
      community = null;
    }
  }

  /// Fetch device location and center the map.
  Future<void> fetchCurrentLocation() async {
    try {
      final location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled && !await location.requestService()) return;

      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied &&
          await location.requestPermission() != PermissionStatus.granted) {
        return;
      }

      final current = await location.getLocation();
      if (current.latitude != null && current.longitude != null) {
        await setPlaceDetails(
          position: LatLng(current.latitude!, current.longitude!),
          placeName: 'Current Location',
        );
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  void clear() {
    _selectedPosition = null;
    _selectedPlaceName = null;
    building = null;
    block = null;
    community = null;
    locationController.clear();
    notifyListeners();
  }
}