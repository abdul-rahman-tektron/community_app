import 'package:community_app/core/model/map/map_data.dart';
import 'package:community_app/core/notifier/location_picker_state.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationMap extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationPickerProvider);
    final locationNotifier = ref.read(locationPickerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Select Location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(25.2048, 55.2708), // Dubai as default
              zoom: 12,
            ),
            onTap: (position) {
              locationNotifier.setPosition(position);
            },
            markers: locationState.selectedPosition != null
                ? {
              Marker(
                markerId: MarkerId('selected'),
                position: locationState.selectedPosition!,
              )
            }
                : {},
          ),
          if (locationState.selectedPosition != null && locationState.selectedPlaceName != null)
            Positioned(
              bottom: 20,
              left: 20.w,
              right: 60.w,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Latitude: ',
                            style: AppFonts.text14.semiBold.style,
                          ),
                          TextSpan(
                            text: '${locationState.selectedPosition!.latitude}',
                            style: AppFonts.text14.regular.style,
                          ),
                        ],
                      ),
                    ),
                    5.verticalSpace,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Longitude: ',
                            style: AppFonts.text14.semiBold.style,
                          ),
                          TextSpan(
                            text: '${locationState.selectedPosition!.longitude}',
                            style: AppFonts.text14.regular.style,
                          ),
                        ],
                      ),
                    ),
                    15.verticalSpace,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Place: ',
                            style: AppFonts.text14.semiBold.style,
                          ),
                          TextSpan(
                            text: locationState.selectedPlaceName ?? '',
                            style: AppFonts.text14.regular.style,
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MapData(
                            latitude: locationState.selectedPosition!.latitude,
                            longitude: locationState.selectedPosition!.longitude,
                            address: locationState.selectedPlaceName ?? "",
                          ),
                        );
                      },
                      text: 'Select This Location',
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
