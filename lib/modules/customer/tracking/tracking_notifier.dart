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

class TrackingNotifier extends BaseChangeNotifier {
  int? jobId;
  LatLng? _employeePosition;
  LatLng _customerPosition = const LatLng(25.267416939850616, 55.33019577131006);
  List<LatLng> _routePoints = [];

  List<JobStatusTrackingData> jobStatusTrackingData = [];
  List<JobStatusResponse> jobStatus = [];

  TrackingNotifier(this.jobId) {
    initializeData();
  }

  initializeData() async {
    await apiJobStatus();
    await apiJobStatusTracking();
  }

  BitmapDescriptor? _employeeIcon;
  BitmapDescriptor? _customerIcon;
  BitmapDescriptor? _transitIcon;

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

    if (_transitIcon != null && _routePoints.isNotEmpty) {
      final transitPoint = _getMidpointAlongPolyline(_routePoints);
      result.add(
        Marker(
          markerId: const MarkerId('transit'),
          position: transitPoint,
          icon: _transitIcon!,
          infoWindow: const InfoWindow(title: 'In Transit'),
          anchor: const Offset(0.5, 0.5),
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
        jobStatusTrackingData = parsed.data!;

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

    _transitIcon = await MapIconHelper.createCustomTransitIcon(
      backgroundColor: Color(0xffe05240),
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
    _routePoints = segments.expand((seg) => seg.points).toList();

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

  double _calculateDistance(LatLng p1, LatLng p2) {
    const R = 6371000; // meters
    final lat1 = p1.latitude * (pi / 180);
    final lat2 = p2.latitude * (pi / 180);
    final dLat = (p2.latitude - p1.latitude) * (pi / 180);
    final dLng = (p2.longitude - p1.longitude) * (pi / 180);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  LatLng _interpolateLatLng(LatLng p1, LatLng p2, double fraction) =>
      LatLng(
        p1.latitude + (p2.latitude - p1.latitude) * fraction,
        p1.longitude + (p2.longitude - p1.longitude) * fraction,
      );

  LatLng _getMidpointAlongPolyline(List<LatLng> points) {
    if (points.isEmpty) throw ArgumentError('Points list cannot be empty');
    if (points.length == 1) return points.first;

    final totalDistance = List.generate(points.length - 1, (i) => _calculateDistance(points[i], points[i + 1]))
        .reduce((a, b) => a + b);
    final halfDistance = totalDistance / 2;

    double accumulatedDistance = 0;
    for (var i = 0; i < points.length - 1; i++) {
      final segmentDistance = _calculateDistance(points[i], points[i + 1]);
      if (accumulatedDistance + segmentDistance >= halfDistance) {
        final remaining = halfDistance - accumulatedDistance;
        final fraction = remaining / segmentDistance;
        return _interpolateLatLng(points[i], points[i + 1], fraction);
      }
      accumulatedDistance += segmentDistance;
    }

    return points.last;
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