import 'package:Xception/core/model/customer/map/map_data.dart';
import 'package:Xception/modules/common/location/location_notifier.dart';
import 'package:Xception/res/api_constants.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationMap extends StatelessWidget {
  /// Pass your Google Places key here (kept flexible).

  /// Optional initial map target & zoom (defaults to Dubai).
  final LatLng initialTarget;
  final double initialZoom;

  const SelectLocationMap({
    super.key,
    this.initialTarget = const LatLng(25.2048, 55.2708),
    this.initialZoom = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationPickerNotifier>(
      create: (_) => LocationPickerNotifier(),
      child: Consumer<LocationPickerNotifier>(
        builder: (context, n, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Select Location'),
              elevation: 0.5,
            ),
            body: Stack(
              children: [
                // ── Google Map ────────────────────────────────────────────────
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialTarget,
                    zoom: initialZoom,
                  ),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: n.setMapController,
                  onTap: (pos) {
                    n.setPlaceDetails(position: pos, placeName: 'Dropped pin');
                  },
                  markers: n.selectedPosition == null
                      ? {}
                      : {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: n.selectedPosition!,
                    ),
                  },
                ),

                // ── Places Search Bar (shown only if a key is provided) ───────
                if (ApiConstants.apiKey.trim().isNotEmpty)
                  Positioned(
                    top: 15.h,
                    left: 15.w,
                    right: 15.w,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(8.r),
                      child: GooglePlaceAutoCompleteTextField(
                        textEditingController: n.locationController,
                        googleAPIKey: ApiConstants.apiKey,
                        debounceTime: 300,
                        countries: const ['ae'],
                        isLatLngRequired: true,

                        // Turn OFF the package cross button; we add our own full-clear button.
                        isCrossBtnShown: false,

                        inputDecoration: InputDecoration(
                          hintText: 'Search your address',
                          isDense: true,
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: const Icon(Icons.search),
                          // ⬇️ Our full-clear button
                          suffixIcon: IconButton(
                            tooltip: 'Clear',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              // clear text + caret + selection
                              n.locationController.clear();
                              n.locationController.selection =
                              const TextSelection.collapsed(offset: 0);

                              // clear map + labels
                              n.clear();

                              // hide keyboard
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        ),

                        getPlaceDetailWithLatLng: (prediction) {
                          final lat = double.tryParse(prediction.lat ?? '');
                          final lng = double.tryParse(prediction.lng ?? '');
                          if (lat != null && lng != null) {
                            n.setPlaceDetails(
                              position: LatLng(lat, lng),
                              placeName: prediction.description ?? 'Selected place',
                            );
                          }
                        },

                        itemClick: (prediction) {
                          final desc = prediction.description ?? '';
                          n.locationController.text = desc;
                          n.locationController.selection =
                              TextSelection.fromPosition(TextPosition(offset: desc.length));
                        },

                        itemBuilder: (context, index, prediction) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 8),
                              Expanded(child: Text(prediction.description ?? '')),
                            ],
                          ),
                        ),

                        containerHorizontalPadding: 10,
                        boxDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),

                // ── Current location button ───────────────────────────────────
                Positioned(
                  bottom: 100.h,
                  right: 10.w,
                  child: FloatingActionButton(
                    heroTag: 'currentLocationBtn',
                    backgroundColor: Colors.white,
                    mini: true,
                    elevation: 2,
                    onPressed: n.fetchCurrentLocation,
                    child: const Icon(Icons.my_location, color: Colors.black87),
                  ),
                ),

                // ── Info card + Select button ─────────────────────────────────
                if (n.selectedPosition != null)
                  Positioned(
                    bottom: 20.h,
                    left: 16.w,
                    right: 16.w,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26.withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.selectedPlaceName ?? 'Dropped pin',
                            style: AppFonts.text16.semiBold.style,
                          ),
                          SizedBox(height: 6.h),
                          Text('Lat: ${n.selectedPosition!.latitude.toStringAsFixed(6)}',
                              style: AppFonts.text14.regular.style),
                          Text('Lng: ${n.selectedPosition!.longitude.toStringAsFixed(6)}',
                              style: AppFonts.text14.regular.style),
                          if ((n.building ?? '').isNotEmpty)
                            Text('Building: ${n.building}', style: AppFonts.text14.regular.style),
                          if ((n.block ?? '').isNotEmpty)
                            Text('Block: ${n.block}', style: AppFonts.text14.regular.style),
                          if ((n.community ?? '').isNotEmpty)
                            Text('Community: ${n.community}', style: AppFonts.text14.regular.style),
                          SizedBox(height: 12.h),
                          CustomButton(
                            text: 'Select This Location',
                            onPressed: () {
                              final pos = n.selectedPosition!;
                              Navigator.pop(
                                context,
                                MapData(
                                  latitude: pos.latitude,
                                  longitude: pos.longitude,
                                  address: n.selectedPlaceName ?? '',
                                  building: n.building ?? '',
                                  block: n.block ?? '',
                                  community: n.community ?? '',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}