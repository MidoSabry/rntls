import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double lat;
  final double lng;
  final String address;

  const LocationResult({
    required this.lat,
    required this.lng,
    required this.address,
  });
}

class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    // 1) location service enabled?
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Location services are disabled.');
    }

    // 2) permission
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }
    if (perm == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied. Enable it from settings.');
    }

    // 3) get position
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4) reverse geocode
    final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    final p = placemarks.isNotEmpty ? placemarks.first : null;

    final address = _formatPlacemark(p) ?? '${pos.latitude}, ${pos.longitude}';

    return LocationResult(
      lat: pos.latitude,
      lng: pos.longitude,
      address: address,
    );
  }

  String? _formatPlacemark(Placemark? p) {
    if (p == null) return null;

    // مثال عنوان لطيف: street, subLocality, locality, administrativeArea, country
    final parts = <String>[
      if ((p.street ?? '').trim().isNotEmpty) p.street!.trim(),
      if ((p.subLocality ?? '').trim().isNotEmpty) p.subLocality!.trim(),
      if ((p.locality ?? '').trim().isNotEmpty) p.locality!.trim(),
      if ((p.administrativeArea ?? '').trim().isNotEmpty) p.administrativeArea!.trim(),
      if ((p.country ?? '').trim().isNotEmpty) p.country!.trim(),
    ];

    if (parts.isEmpty) return null;
    return parts.join(', ');
  }
}