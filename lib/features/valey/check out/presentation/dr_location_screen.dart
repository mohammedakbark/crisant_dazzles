import 'dart:math' as math;

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/app_button.dart';
import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/features/valey/check%20out/data/provider/driver_check_out_controller.dart';
import 'package:dazzles/features/valey/home/data/model/dr_check_out_valet_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class DrVehicleLocationScreen extends StatefulWidget {
  final DrCheckOutValetInfoModel valetInfo;
  const DrVehicleLocationScreen({super.key, required this.valetInfo});

  @override
  State<DrVehicleLocationScreen> createState() => _VehicleLocationScreenState();
}

class _VehicleLocationScreenState extends State<DrVehicleLocationScreen> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  StreamSubscription<Position>? _positionStream;
  double _distanceToVehicle = 0.0;
  // bool _isNearVehicle = false;
  bool _isLoading = true;
  String _locationStatus = "Getting your location...";

  // Distance threshold in meters to consider "reached" (default: 50 meters)
  // static const double REACHED_THRESHOLD = 2.0;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationStatus = "Location permission denied";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus = "Location permission permanently denied";
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _locationStatus = "Location found";
      });

      _updateMarkers();
      _calculateDistance();
      _startLocationUpdates();
    } catch (e) {
      setState(() {
        _locationStatus = "Error getting location: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _updateMarkers();
      _calculateDistance();
      _updatePolyline();
    });
  }

//  late BitmapDescriptor carIcon;
//   late BitmapDescriptor me;

//   void setCustomerMarkerIcon() async {
//     carIcon = await BitmapDescriptor.asset(
//       const ImageConfiguration(size: Size(48, 48)),
//       'assets/images/car.png',
//     );

//     me = await BitmapDescriptor.asset(
//       const ImageConfiguration(size: Size(48, 48)),
//       'assets/images/driver.png',
//     );
//     setState(() {

//     });
//   }
  void _updateMarkers() {
    if (_currentPosition == null) return;

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('current_location'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId('vehicle_location'),
          position: LatLng(widget.valetInfo.latt, widget.valetInfo.long),
          infoWindow: InfoWindow(title: widget.valetInfo.vehicleNumber),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }

  void _updatePolyline() {
    if (_currentPosition == null) return;

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            LatLng(widget.valetInfo.latt, widget.valetInfo.long),
          ],
          color: Colors.blue,
          width: 3,
          patterns: [PatternItem.dash(10), PatternItem.gap(5)],
        ),
      };
    });
  }

  void _calculateDistance() {
    if (_currentPosition == null) return;

    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      widget.valetInfo.latt,
      widget.valetInfo.long,
    );

    setState(() {
      _distanceToVehicle = distance;
      // _isNearVehicle = distance <= REACHED_THRESHOLD;
    });
  }

  String _formatDistance(double distance) {
    if (distance < 1000) {
      return "${distance.toStringAsFixed(0)} m";
    } else {
      return "${(distance / 1000).toStringAsFixed(2)} km";
    }
  }

  Future<void> _openNavigation() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${widget.valetInfo.latt},${widget.valetInfo.long}&travelmode=driving";

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open navigation')),
      );
    }
  }

  void _centerOnVehicle() {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(widget.valetInfo.latt, widget.valetInfo.long),
        ),
      );
    }
  }

  void _centerOnUser() {
    if (_controller != null && _currentPosition != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _fitBothLocations() {
    if (_controller != null && _currentPosition != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          math.min(_currentPosition!.latitude, widget.valetInfo.latt),
          math.min(_currentPosition!.longitude, widget.valetInfo.long),
        ),
        northeast: LatLng(
          math.max(_currentPosition!.latitude, widget.valetInfo.latt),
          math.max(_currentPosition!.longitude, widget.valetInfo.long),
        ),
      );
      _controller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('${widget.valetInfo.vehicleNumber}'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnUser,
            tooltip: 'Center on me',
          ),
          IconButton(
            icon: const Icon(Icons.directions_car),
            onPressed: _centerOnVehicle,
            tooltip: 'Center on vehicle',
          ),
          IconButton(
            icon: const Icon(Icons.fit_screen),
            onPressed: _fitBothLocations,
            tooltip: 'Fit both locations',
          ),
          IconButton(
              onPressed: _openNavigation,
              icon: Icon(
                SolarIconsBold.map,
                color: AppColors.kDeepPurple,
              )),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLoading(),
                  const SizedBox(height: 16),
                  Text(
                    _locationStatus,
                    style: AppStyle.mediumStyle(),
                  ),
                ],
              ),
            )
          : _currentPosition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _locationStatus,
                        style: AppStyle.mediumStyle(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeLocation,
                        child: Text(
                          'Retry',
                          style: AppStyle.mediumStyle(),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Distance and status card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // color: _isNearVehicle
                        //     ? Colors.green.shade100
                        //     : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green,
                          // color: _isNearVehicle ? Colors.green : Colors.blue,
                          width: .5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Distance to ${widget.valetInfo.vehicleNumber}',
                                    style: AppStyle.boldStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _formatDistance(_distanceToVehicle),
                                    style: AppStyle.boldStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                  // _isNearVehicle
                                  //     ? Icons.check_circle
                                  //     : Icons.navigation,
                                  Icons.check_circle,
                                  size: 32,
                                  // color: _isNearVehicle
                                  //     ? Colors.green.withAlpha(200)
                                  //     : Colors.blue.withAlpha(200),
                                  color: Colors.green.withAlpha(200)),
                            ],
                          ),
                          // if (_isNearVehicle)
                          //   Container(
                          //     margin: const EdgeInsets.only(top: 5),
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 12, vertical: 6),
                          //     decoration: BoxDecoration(
                          //       color: Colors.green.withAlpha(200),
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     child: Text(
                          //       'You have reached your vehicle!',
                          //       style: AppStyle.boldStyle(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    // Map
                    Expanded(
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          _fitBothLocations();
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              widget.valetInfo.latt, widget.valetInfo.long),
                          zoom: 15,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                      ),
                    ),
                    // Bottom buttons

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      color: AppColors.kWhite,
                      child: Row(
                        children: [
                          Expanded(
                              child: Consumer(builder: (context, ref, child) {
                            return ref
                                    .watch(driverCheckOutControllerProvider)
                                    .isLoading
                                ? AppLoading()
                                : InkWell(
                                    // onTap: _isNearVehicle
                                    //     ? () async {
                                    //         await ref
                                    //             .read(
                                    //                 driverCheckOutControllerProvider
                                    //                     .notifier)
                                    //             .onTakeVideo(
                                    //                 context,
                                    //                 widget.valetInfo.valetId
                                    //                     .toString());
                                    //       }
                                    //     : null,
                                    onTap: () async {
                                      await ref
                                          .read(driverCheckOutControllerProvider
                                              .notifier)
                                          .onTakeVideo(
                                              context,
                                              widget.valetInfo.valetId
                                                  .toString());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // color: _isNearVehicle
                                          //     ? Colors.green
                                          //     : Colors.grey,
                                          color: Colors.green),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Icon(_isNearVehicle
                                          //     ? Icons.check_circle
                                          //     : Icons.location_disabled),
                                          Icon(Icons.check_circle),
                                          AppSpacer(
                                            wp: .01,
                                          ),
                                          Text(
                                            // _isNearVehicle
                                            //     ? 'Take video and Complete delivery'
                                            //     : 'Get Closer to Enable',
                                            'Take video and Complete delivery',
                                            style: AppStyle.boldStyle(),
                                          )
                                        ],
                                      ),
                                    ));
                          })),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
