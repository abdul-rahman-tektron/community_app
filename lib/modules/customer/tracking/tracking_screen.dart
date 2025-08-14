import 'package:community_app/modules/customer/tracking/tracking_notifier.dart';
import 'package:community_app/modules/customer/tracking/tracking_steps.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatelessWidget {
  final int? jobId;
  const TrackingScreen({super.key, this.jobId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackingNotifier(jobId)
        ..loadMarkerIcons()
        ..updateEmployeePosition(
          const LatLng(25.23420588161868, 55.2654526622921),
        ),
      child: Consumer<TrackingNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CustomButton(
                  text: "Call - Abdul Rahman",
                  onPressed: () {},
                ),
              ),
            ],
            body: Column(
              children: [
                _buildMapSection(context, notifier),
                _buildInfoSection(notifier),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapSection(BuildContext context, TrackingNotifier notifier) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: notifier.setMapController,
            initialCameraPosition: CameraPosition(
              target: notifier.employeePosition ?? notifier.customerPosition,
              zoom: 14,
            ),
            markers: notifier.markers,
            polylines: notifier.polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),
          closeMapButton(context),
        ],
      ),
    );
  }

  Widget _buildInfoSection(TrackingNotifier notifier) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: infoCard(
                    icon: LucideIcons.clockFading,
                    iconBg: const Color(0xffeff7ef),
                    iconColor: Colors.green,
                    title: 'Est. Distance:',
                    value: notifier.estimatedDistance ?? "Loading...",
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: infoCard(
                    icon: LucideIcons.rulerDimensionLine,
                    iconBg: const Color(0xfffdf5e7),
                    iconColor: Colors.orange,
                    title: 'Est. Duration:',
                    value: notifier.estimatedDuration ?? "Loading...",
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            CustomLinearProgressIndicator(percentage: 20),
            15.verticalSpace,
            TrackingStepsWidget(
              currentStep: notifier.jobStatusTrackingData.isNotEmpty
                  ? notifier.jobStatusTrackingData.last
                  : null,
              jobStatus: notifier.jobStatus,
            )
          ],
        ),
      ),
    );
  }

  Widget closeMapButton(BuildContext context) {
   return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 8,
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close map',
        ),
      ),
    );
  }

  Widget infoCard({IconData? icon, Color? iconColor, Color? iconBg, String? title, String? value}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 7),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? "", style: AppFonts.text14.regular.style),
                const SizedBox(height: 2),
                Text(value ?? "", style: AppFonts.text18.regular.style),
              ],
            ),
          ),
        ],
      ),
    );
  }
}