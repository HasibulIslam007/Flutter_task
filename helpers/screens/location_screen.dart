import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_1/features/alarm_screen.dart'; // ✅ Update this path if needed

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
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _position = pos;
          _locationMessage =
              "Latitude: ${pos.latitude.toStringAsFixed(4)}, Longitude: ${pos.longitude.toStringAsFixed(4)}";
        });
      } catch (e) {
        setState(() {
          _locationMessage = "Failed to fetch location: $e";
        });
      }
    } else if (status.isDenied) {
      setState(() {
        _locationMessage = "Location permission denied.";
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      setState(() {
        _locationMessage =
            "Location permission permanently denied. Please enable it in settings.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Welcome! Your\nPersonalized Alarm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Allow us to sync your sunset alarm\nbased on your location.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ClipOval(
                child: Image.asset(
                  'assets/images/location_art.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _getLocation,
                icon: const Icon(Icons.location_on_outlined),
                label: const Text("Use Current Location"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Home"),
              ),
              const SizedBox(height: 30),
              Text(
                _locationMessage,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
