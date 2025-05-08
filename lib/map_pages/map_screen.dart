import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intro_screens/core/models/provider_model.dart'; // Import ProviderModel
import 'package:intro_screens/providers/model_provider.dart'; // Import ModelProvider
import 'package:intro_screens/routes/app_routes.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../core/services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

    setState(() {
      _isUpdating = true;
    });

    bool success = await _apiService.updateLocation(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    setState(() {
      _isUpdating = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location updated successfully!")),
      );
      Navigator.pushNamed(context, AppRoutes.navigationMenu);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update location!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the providers list from the ModelProvider
    final providerModel = Provider.of<ModelProvider<ProviderModel>>(context);
    final providers = providerModel.items; // List of ProviderModel objects

    print("Providers count: ${providers.length}");
    for (var provider in providers) {
      print("Provider: ${provider.username}, Lat: ${provider.latitude}, Lng: ${provider.longitude}");
    }

    return SafeArea(
      child: Scaffold(
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
                // Marker for the current user location
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentPosition!,
                ),

                // Add markers for all providers
                ...providers.map((provider) {
                  return Marker(
                    markerId: MarkerId(provider.providerId),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    position: LatLng(provider.latitude, provider.longitude),
                    infoWindow: InfoWindow(
                      title: provider.username,
                      snippet: "⭐ Rating: ${provider.rating.toStringAsFixed(1)}",
                    ),
                  );
                }).toSet(),
              },
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _isUpdating ? null : _confirmLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3A3434),
                  minimumSize: const Size(60, 60),
                ),
                child: _isUpdating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm Location",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}