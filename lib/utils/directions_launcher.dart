import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openDirectionsFromCurrentLocation(
  BuildContext context, {
  required double destinationLat,
  required double destinationLng,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!context.mounted) return;

  if (!serviceEnabled) {
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Please enable location services first.'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Settings',
          onPressed: Geolocator.openLocationSettings,
        ),
      ),
    );
    return;
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (!context.mounted) return;

  if (permission == LocationPermission.denied) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Location permission is required.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (permission == LocationPermission.deniedForever) {
    messenger.showSnackBar(
      SnackBar(
        content: const Text(
          'Location permission is permanently denied. Enable it in settings.',
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Settings',
          onPressed: Geolocator.openAppSettings,
        ),
      ),
    );
    return;
  }

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
  if (!context.mounted) return;

  final uri = Uri.https('www.google.com', '/maps/dir/', {
    'api': '1',
    'origin': '${position.latitude},${position.longitude}',
    'destination': '$destinationLat,$destinationLng',
    'travelmode': 'driving',
  });

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!context.mounted || launched) return;

  messenger.showSnackBar(
    const SnackBar(
      content: Text('Could not open directions.'),
      backgroundColor: Colors.red,
    ),
  );
}
