import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intro_screens/core/models/provider_model.dart';
import 'package:intro_screens/providers/model_provider.dart';
import 'package:intro_screens/screens/home/service_requests_screen.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../core/services/api_service.dart';
import '../../core/services/booking_storage.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer();
  final ApiService _apiService = ApiService();
  LatLng? _currentPosition;
  bool _isUpdating = false;

  // Add variables to store booking data
  int? serviceId;
  String? providerId;
  int? carId;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadBookingData(); // Load stored booking data
  }

  // Add method to load booking data
  Future<void> _loadBookingData() async {
    Map<String, dynamic> bookingData =
        await BookingStorage().getAllBookingData();

    setState(() {
      serviceId = bookingData['serviceId'];
      providerId = bookingData['providerId'];
      carId = bookingData['carId'];
    });

    print('Loaded Service ID: $serviceId');
    print('Loaded Provider ID: $providerId');
    print('Loaded Car ID: $carId');
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData locationData = await _locationController.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      setState(() {
        _currentPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 13),
        ),
      );
    }
  }

  Future<void> _confirmLocation() async {
    if (_currentPosition == null) return;

    // Check if all required booking data is available
    if (serviceId == null || providerId == null || carId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Missing booking information. Please go back and select all required options.")),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    // First update location
    bool locationUpdateSuccess = await _apiService.updateLocation(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    if (!locationUpdateSuccess) {
      setState(() {
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update location!")),
      );
      return;
    }

    // Then create service request
    bool serviceRequestSuccess = await _apiService.requestService(
        serviceId!,
        carId!,
        providerId!,
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        "");

    setState(() {
      _isUpdating = false;
    });

    if (serviceRequestSuccess) {
      // Clear the stored booking data after successful request
      await BookingStorage().clearAllBookingData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service request created successfully!")),
      );
      // Navigator.pushNamed(context, AppRoutes.navigationMenu);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ServiceRequestsScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create service request!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerModel = Provider.of<ModelProvider<ProviderModel>>(context);
    final providers = providerModel.items;

    print("*-*-*-*-*-*-*-*-**-*-*Providers count: ${providers.length}");
    for (var provider in providers) {
      print(
          "Provider: ${provider.username}, Lat: ${provider.latitude}, Lng: ${provider.longitude}");
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Confirm Your Location',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _currentPosition == null
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor))
                : GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    initialCameraPosition:
                        CameraPosition(target: _currentPosition!, zoom: 13),
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _currentPosition!,
                      ),
                      ...providers.map((provider) {
                        return Marker(
                          markerId: MarkerId(provider.providerId),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          position:
                              LatLng(provider.latitude, provider.longitude),
                          infoWindow: InfoWindow(
                            title: provider.username,
                            snippet:
                                "⭐ Rating: ${provider.rating.toStringAsFixed(1)}",
                          ),
                        );
                      }).toSet(),
                    },
                  ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isUpdating ? null : _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3A3434),
                    ),
                    child: _isUpdating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Confirm Location & Request Service",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
