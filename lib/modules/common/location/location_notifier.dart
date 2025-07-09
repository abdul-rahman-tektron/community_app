import 'package:community_app/core/base/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPickerNotifier extends BaseChangeNotifier {
  LatLng? _selectedPosition;
  String? _selectedPlaceName;

  final locationController = TextEditingController();
  GoogleMapController? _mapController;

  String? building;
  String? block;
  String? community;

  LatLng? get selectedPosition => _selectedPosition;
  String? get selectedPlaceName => _selectedPlaceName;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> setPlaceDetails({
    required LatLng position,
    required String placeName,
  }) async {
    await _fillAddressDetailsFromLatLng(position);
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _fillAddressDetailsFromLatLng(LatLng position) async {
    try {
      _selectedPosition = position;

      final placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placeMarks.isNotEmpty) {
        final p = placeMarks.first;

        final street = p.thoroughfare ?? '';
        final blockName = p.subLocality ?? '';
        final city = p.administrativeArea ?? '';

        final List<String> addressParts = [
          if (street.isNotEmpty) street,
          if (blockName.isNotEmpty) blockName,
          if (city.isNotEmpty) city,
        ];

        _selectedPlaceName = addressParts.join(", ");

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

  Future<void> fetchCurrentLocation() async {
    try {
      final location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final currentLocation = await location.getLocation();
      final position = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      await setPlaceDetails(position: position, placeName: "Current Location");
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
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
