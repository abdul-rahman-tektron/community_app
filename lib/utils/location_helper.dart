import 'dart:convert';

import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationHelper {
  static final Location _location = Location();
  static LocationData? _currentLocation;

  /// Call this once in `main()` or app startup
  static Future<void> initialize() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
  }

  static Future<bool> requestService() async {
    return await _location.requestService();
  }

  /// Fetch the user's current location (on demand)
  static Future<LocationData?> getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
      return _currentLocation;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  /// Start listening for continuous location updates
  static void startTracking(Function(LocationData) onLocationChanged) {
    _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 2000, // every 2 seconds
      distanceFilter: 10, // every 10 meters
    );
    _location.onLocationChanged.listen(onLocationChanged);
  }

  /// Stop listening to location updates
  static void stopTracking() {
    // No direct stop method, but canceling listener externally will work
  }

  /// Calculate distance in KM using Haversine formula
  static double calculateDistanceKm(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // pi/180
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2*R*asin...
  }

  /// Extract coordinates from your address string
  static Map<String, double?> parseLatLng(String address) {
    try {
      final startIndex = address.indexOf('{');
      final endIndex = address.indexOf('}');
      if (startIndex == -1 || endIndex == -1) return {"lat": null, "lng": null};

      final jsonString = address.substring(startIndex, endIndex + 1)
          .replaceAll("Latitude:", "\"Latitude\":")
          .replaceAll("Longitude:", "\"Longitude\":");
      final data = jsonDecode(jsonString);
      return {
        "lat": (data["Latitude"] as num?)?.toDouble(),
        "lng": (data["Longitude"] as num?)?.toDouble(),
      };
    } catch (e) {
      print("Error parsing lat/lng: $e");
      return {"lat": null, "lng": null};
    }
  }

  /// Extract clean address (before `{}`)
  static String parseCleanAddress(String address) {
    final braceIndex = address.indexOf('{');
    return braceIndex == -1 ? address : address.substring(0, braceIndex).trim();
  }

  static Future<bool> isServiceEnabled() async => await _location.serviceEnabled();

  static Future<PermissionStatus> checkAndRequestPermission() async {
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }
    return permission;
  }
}
