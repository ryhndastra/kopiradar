import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsPage extends StatefulWidget {
  final LatLng destination;

  const MapsPage({super.key, required this.destination});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  late LatLng destination;
  bool _isMapReady = false;

  Set<Marker> markers = {};
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    destination = widget.destination;
    _initLocation();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  void _zoomToBounds() {
    if (!_isMapReady || currentLocation == null || mapController == null)
      return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        currentLocation!.latitude < destination.latitude
            ? currentLocation!.latitude
            : destination.latitude,
        currentLocation!.longitude < destination.longitude
            ? currentLocation!.longitude
            : destination.longitude,
      ),
      northeast: LatLng(
        currentLocation!.latitude > destination.latitude
            ? currentLocation!.latitude
            : destination.latitude,
        currentLocation!.longitude > destination.longitude
            ? currentLocation!.longitude
            : destination.longitude,
      ),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    _updateCurrentLocation(position);

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 10,
          ),
        ).listen((Position newPos) {
          _updateCurrentLocation(newPos);
        });
  }

  void _updateCurrentLocation(Position pos) {
    currentLocation = LatLng(pos.latitude, pos.longitude);

    setState(() {
      markers = {
        Marker(
          markerId: const MarkerId("destination"),
          position: destination,
          infoWindow: const InfoWindow(title: 'Tujuan'),
        ),
      };
    });

    if (mapController != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          currentLocation!.latitude < destination.latitude
              ? currentLocation!.latitude
              : destination.latitude,
          currentLocation!.longitude < destination.longitude
              ? currentLocation!.longitude
              : destination.longitude,
        ),
        northeast: LatLng(
          currentLocation!.latitude > destination.latitude
              ? currentLocation!.latitude
              : destination.latitude,
          currentLocation!.longitude > destination.longitude
              ? currentLocation!.longitude
              : destination.longitude,
        ),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
      });
    }
  }

  Future<void> _startNavigation() async {
    if (currentLocation == null) return;

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${currentLocation!.latitude},${currentLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: destination,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                    setState(() => _isMapReady = true);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _zoomToBounds();
                    });
                  },

                  myLocationEnabled: true,
                  markers: markers,
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _startNavigation,
                      icon: const Icon(Icons.navigation),
                      label: const Text("Mulai Navigasi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
