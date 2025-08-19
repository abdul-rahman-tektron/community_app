import 'dart:math';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/job_status_tracking_request.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/job_status_tracking_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/jobs_status_response.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/map_icon_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingNotifier extends BaseChangeNotifier {
  int? jobId;
  LatLng? _employeePosition;
  LatLng _customerPosition = const LatLng(25.268938, 55.305338);

  List<JobStatusTrackingData> jobStatusTrackingData = [];
  List<JobStatusResponse> jobStatus = [];
  PartyInfo? partyInfo;

  TrackingNotifier(this.jobId) {
    initializeData();
  }

  initializeData() async {
    await apiJobStatus();
    await apiJobStatusTracking();
  }

  BitmapDescriptor? _employeeIcon;
  BitmapDescriptor? _customerIcon;

  String? _estimatedDuration;  // e.g. "15 mins"
  String? _estimatedDistance;  // e.g. "10 km"

  LatLng? get employeePosition => _employeePosition;
  LatLng get customerPosition => _customerPosition;

  String? get estimatedDuration => _estimatedDuration;
  String? get estimatedDistance => _estimatedDistance;

  GoogleMapController? _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    _fitMapToMarkers();
  }

  Future<void> _fitMapToMarkers() async {
    if (_mapController == null || _employeePosition == null) return;

    final southwest = LatLng(
      min(_employeePosition!.latitude, _customerPosition.latitude),
      min(_employeePosition!.longitude, _customerPosition.longitude),
    );

    final northeast = LatLng(
      max(_employeePosition!.latitude, _customerPosition.latitude),
      max(_employeePosition!.longitude, _customerPosition.longitude),
    );

    final bounds = LatLngBounds(southwest: southwest, northeast: northeast);

    await _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  Set<Marker> get markers {
    final result = <Marker>{};

    if (_employeePosition != null && _employeeIcon != null) {
      result.add(
        Marker(
          markerId: const MarkerId('employee'),
          position: _employeePosition!,
          icon: _employeeIcon!,
          infoWindow: const InfoWindow(title: 'Employee'),
          anchor: const Offset(0.5, 1.0),
        ),
      );
    }

    if (_customerIcon != null) {
      result.add(
        Marker(
          markerId: const MarkerId('customer'),
          position: _customerPosition,
          icon: _customerIcon!,
          infoWindow: const InfoWindow(title: 'Customer'),
          anchor: const Offset(0.5, 1.0),
        ),
      );
    }

    return result;
  }

  Future<void> apiJobStatusTracking() async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = await CustomerJobsRepository.instance
          .apiJobStatusTracking(JobStatusTrackingRequest(jobId: jobId)) as JobStatusTrackingResponse;

      if (parsed.success == true && parsed.data != null) {
        jobStatusTrackingData = parsed.data?.statusTracking ?? [];
        partyInfo = parsed.data?.partyInfo?[0] ?? PartyInfo() ;

        updateEmployeePosition(LatLng(partyInfo?.vendorLatitude ?? 0, partyInfo?.vendorLongitude ?? 0));
        updateCustomerPosition(LatLng(partyInfo?.latitude ?? 0, partyInfo?.longitude ?? 0));
        print("jobStatusTrackingData");
        print(jobStatusTrackingData);
      }
    } catch (e, stackTrace) {
      print("❌ Error fetching quotation requests: $e");
      print("Stack: $stackTrace");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> apiJobStatus() async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = await CustomerJobsRepository.instance
          .apiJobStatus();

      if (parsed is List<JobStatusResponse> && parsed.isNotEmpty) {
        jobStatus = parsed;

        print("jobStatusData");
        print(jobStatus);
      }
    } catch (e, stackTrace) {
      print("❌ Error fetching quotation requests: $e");
      print("Stack: $stackTrace");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<ColoredPolylineSegment> _coloredRouteSegments = [];

  Set<Polyline> get polylines {
    if (_coloredRouteSegments.isEmpty) return {};

    return _coloredRouteSegments.map((segment) {
      return Polyline(
        polylineId: PolylineId(segment.id),
        points: segment.points,
        color: segment.color,
        width: 3,
      );
    }).toSet();
  }

  void updateEmployeePosition(LatLng position) {
    _employeePosition = position;
    _fetchRoute();
    notifyListeners();
  }

  void updateCustomerPosition(LatLng position) {
    _customerPosition = position;
    _fetchRoute();
    notifyListeners();
  }

  Future<void> loadMarkerIcons() async {
    _employeeIcon = await MapIconHelper.createCustomMarkerIcon(
      iconData: LucideIcons.circleUser,
      backgroundColor: Color(0xff3f89cc),
      iconColor: Colors.white,
    );

    _customerIcon = await MapIconHelper.createCustomMarkerIcon(
      iconData: LucideIcons.house,
      backgroundColor: Color(0xff3f89cc),
      iconColor: Colors.white,
    );

    notifyListeners();
  }

  Future<void> _fetchRoute() async {
    if (_employeePosition == null || _customerPosition == null) return;

    final origin = '${_employeePosition!.latitude},${_employeePosition!.longitude}';
    final destination = '${_customerPosition.latitude},${_customerPosition.longitude}';

    try {
      final responseData = await CustomerJobsRepository.instance.getRouteWithTraffic(
        origin: origin,
        destination: destination,
      );

      if (_isValidRouteResponse(responseData)) {
        _processRouteData(responseData);
        notifyListeners();
        _fitMapToMarkers();
      } else {
        debugPrint('No valid route found in API response.');
      }
    } catch (e) {
      debugPrint('Failed to fetch route: $e');
    }
  }

  bool _isValidRouteResponse(Map<String, dynamic> data) {
    return data['routes'] != null &&
        (data['routes'] as List).isNotEmpty &&
        (data['routes'][0]['legs'] as List).isNotEmpty;
  }

  void _processRouteData(Map<String, dynamic> data) {
    final route = data['routes'][0];
    final legs = route['legs'] as List;

    List<ColoredPolylineSegment> segments = [];
    int segmentIndex = 0;

    int totalDurationSec = 0;
    int totalDistanceMeters = 0;

    for (var leg in legs) {
      final steps = leg['steps'] as List;

      totalDurationSec += leg['duration']['value'] as int;
      totalDistanceMeters += leg['distance']['value'] as int;

      for (var step in steps) {
        final stepPointsEncoded = step['polyline']['points'];
        final stepPoints = PolylinePoints().decodePolyline(stepPointsEncoded)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList();

        final duration = step['duration']['value'] as int;
        final distance = step['distance']['value'] as int;

        final speed = distance / duration; // m/s

        final polylineColor = _getTrafficColor(speed);

        segments.add(ColoredPolylineSegment(
          id: 'segment_$segmentIndex',
          points: stepPoints,
          color: polylineColor,
        ));
        segmentIndex++;
      }
    }

    _coloredRouteSegments = segments;

    _estimatedDuration = _formatDuration(totalDurationSec);
    _estimatedDistance = _formatDistance(totalDistanceMeters);
  }

  Color _getTrafficColor(double speed) {
    if (speed < 3) {
      return Colors.red;
    } else if (speed < 6) {
      return Colors.orange;
    } else {
      return AppColors.polylineColor; // normal traffic color
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    } else {
      return '${duration.inMinutes} min';
    }
  }

  String _formatDistance(int meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    } else {
      return '$meters m';
    }
  }
}


class ColoredPolylineSegment {
  final String id;
  final List<LatLng> points;
  final Color color;

  ColoredPolylineSegment({
    required this.id,
    required this.points,
    required this.color,
  });
}