import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerState {
  final LatLng? selectedPosition;
  final String? selectedPlaceName;

  LocationPickerState({
    this.selectedPosition,
    this.selectedPlaceName,
  });

  LocationPickerState copyWith({
    LatLng? selectedPosition,
    String? selectedPlaceName,
  }) {
    return LocationPickerState(
      selectedPosition: selectedPosition ?? this.selectedPosition,
      selectedPlaceName: selectedPlaceName ?? this.selectedPlaceName,
    );
  }
}

class LocationPickerNotifier extends StateNotifier<LocationPickerState> {
  LocationPickerNotifier() : super(LocationPickerState());

  Future<void> setPosition(LatLng position) async {
    state = state.copyWith(selectedPosition: position, selectedPlaceName: null);

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final name = "${placemark.name}, ${placemark.locality}, ${placemark.country}";
        state = state.copyWith(selectedPlaceName: name);
      } else {
        state = state.copyWith(selectedPlaceName: "Unknown location");
      }
    } catch (e) {
      state = state.copyWith(selectedPlaceName: "Unknown location");
    }
  }
}

final locationPickerProvider = StateNotifierProvider<LocationPickerNotifier, LocationPickerState>(
      (ref) => LocationPickerNotifier(),
);
