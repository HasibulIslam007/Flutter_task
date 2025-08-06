import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../common_widgets/primary_button.dart';
import 'alarm_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _locationMessage = "Fetching location...";
  Position? _position;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

Future<void> _getLocation() async {
  final status = await Permission.location.request();

  if (status.isGranted) {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          forceLocationManager: true,
        ),
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      String address;
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address = [
          place.name,
          place.street,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      } else {
        address = "No address found.";
      }

      setState(() {
        _position = pos;
        _locationMessage = address;
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Location error: $e";
      });
    }
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
    setState(() {
      _locationMessage =
          "Location permission permanently denied. Enable it in settings.";
    });
  } else {
    setState(() {
      _locationMessage = "Location permission denied.";
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                "Welcome! Your\nPersonalized Alarm",
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                "Allow us to sync your sunset alarm\nbased on your location.",
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 40),
              ClipOval(
                child: Image.asset(
                  'assets/images/location.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),

              // ✅ Use PrimaryButton with icon
              PrimaryButton(
                text: "Use Current Location",
                icon: Icons.location_on_outlined,
                onPressed: _getLocation,
              ),
              const SizedBox(height: 16),

              // ✅ Use PrimaryButton without icon
              PrimaryButton(
                text: "Alarm",
                onPressed: () {
                  if (_position != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlarmScreen(
                          position: _position!,
                          address: _locationMessage,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fetch your location first."),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              Text(
                _locationMessage,
                style: AppTextStyles.subtitle.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
