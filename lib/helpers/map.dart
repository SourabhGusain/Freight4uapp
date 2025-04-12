import 'package:Freight4u/helpers/get.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

Future<bool> _handleLocationPermission(context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Get.viewMessage(
    //     context, 'Location services are disabled. Please enable the services');
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Get.viewMessage(context, 'Location permissions are denied');
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Get.viewMessage(context,
    //     'Location permissions are permanently denied, we cannot request permissions.');
    return false;
  }
  return true;
}

Future<String> googleAutoComplete(context) async {
  String loc = "";
  try {} catch (e) {
    Get.viewMessage(context, e);
  } finally {
    return loc;
  }
}

Future<Position?> getCurrentPosition(context) async {
  final hasPermission = await _handleLocationPermission(context);
  print("$hasPermission -----------");

  if (!hasPermission) return null;

  return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
    return position;
    // setState(() => _currentPosition = position);
  }).catchError((e) {
    // Get.viewMessage(context, e);
    return null;
  });
}

// Function to calculate the distance between two points using their coordinates
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371000; // Radius of the Earth in meters

  double dLat = _degreesToRadians(lat2 - lat1);
  double dLon = _degreesToRadians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(_degreesToRadians(lat1)) *
          cos(_degreesToRadians(lat2)) *
          pow(sin(dLon / 2), 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}
