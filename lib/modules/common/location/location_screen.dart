import 'package:community_app/core/model/map/map_data.dart';
import 'package:community_app/modules/common/location/location_notifier.dart';
import 'package:community_app/res/api_constants.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:provider/provider.dart';

class SelectLocationMap extends StatelessWidget {
  const SelectLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationPickerNotifier>(
      create: (_) => LocationPickerNotifier(),
      child: Consumer<LocationPickerNotifier>(
        builder: (context, locationNotifier, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Select Location')),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(25.2048, 55.2708),
                    zoom: 12,
                  ),
                  markers: locationNotifier.selectedPosition != null
                      ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: locationNotifier.selectedPosition!,
                    )
                  }
                      : {},
                  onTap: (pos) {
                    locationNotifier.setPlaceDetails(
                      position: pos,
                      placeName: "Custom Location",
                    );
                  },
                  onMapCreated: locationNotifier.setMapController,
                ),

                // Search Bar
                Positioned(
                  top: 15.h,
                  left: 15.w,
                  right: 15.w,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8.r),
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: locationNotifier.locationController,
                      googleAPIKey: ApiConstants.apiKey,
                      debounceTime: 800,
                      countries: const ["ae"],
                      isLatLngRequired: true,
                      placeType: PlaceType.address,
                      formSubmitCallback: () {},
                      inputDecoration: InputDecoration(
                        hintText: "Search your address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      itemClick: (prediction) {
                        if (prediction.lat != null && prediction.lng != null) {
                          locationNotifier.setPlaceDetails(
                            position: LatLng(
                              double.parse(prediction.lat!),
                              double.parse(prediction.lng!),
                            ),
                            placeName: prediction.description ?? "",
                          );
                        }
                      },
                    ),
                  ),
                ),

                // Floating button for current location
                Positioned(
                  bottom: 100.h,
                  right: 5.w,
                  child: FloatingActionButton(
                    heroTag: 'currentLocationBtn',
                    backgroundColor: Colors.white,
                    mini: true,
                    elevation: 3,
                    onPressed: () {
                      locationNotifier.fetchCurrentLocation();
                    },
                    child: const Icon(Icons.my_location, color: Colors.black87),
                  ),
                ),

                // Info card
                if (locationNotifier.selectedPosition != null)
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locationNotifier.selectedPlaceName ?? "Unknown place",
                            style: AppFonts.text16.semiBold.style,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Lat: ${locationNotifier.selectedPosition!.latitude.toStringAsFixed(6)}",
                            style: AppFonts.text14.regular.style,
                          ),
                          Text(
                            "Lng: ${locationNotifier.selectedPosition!.longitude.toStringAsFixed(6)}",
                            style: AppFonts.text14.regular.style,
                          ),
                          if (locationNotifier.building?.isNotEmpty ?? false)
                            Text("Building: ${locationNotifier.building}"),
                          if (locationNotifier.block?.isNotEmpty ?? false)
                            Text("Block: ${locationNotifier.block}"),
                          if (locationNotifier.community?.isNotEmpty ?? false)
                            Text("Community: ${locationNotifier.community}"),
                          SizedBox(height: 12.h),
                          CustomButton(
                            text: "Select This Location",
                            onPressed: () {
                              Navigator.pop(
                                context,
                                MapData(
                                  latitude: locationNotifier.selectedPosition!.latitude,
                                  longitude: locationNotifier.selectedPosition!.longitude,
                                  address: locationNotifier.selectedPlaceName ?? "",
                                  building: locationNotifier.building ?? "",
                                  block: locationNotifier.block ?? "",
                                  community: locationNotifier.community ?? "",
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
