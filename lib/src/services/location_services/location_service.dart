import 'dart:async';

import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:dpr_patient/src/business_logics/models/user_location.dart';

class LocationService {
  // Keep track of current Location
  UserLocation _currentLocation = UserLocation(latitude: 0, longitude: 0);
  Location location = Location();
  List<geo.Placemark> _placemarks = [];

  // Continuously emit location updates
  final StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();

  // init with constructor
  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          _locationController.add(UserLocation(
            latitude: locationData.latitude ?? 0,
            longitude: locationData.longitude ?? 0,
          ));
        });
      }
    });
  }

  // get location stream data
  Stream<UserLocation> get locationStream => _locationController.stream;
  List<geo.Placemark> get placemarks => _placemarks;

  // get location instance
  Future<List<geo.Placemark>> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude ?? 0,
        longitude: userLocation.longitude ?? 0,
      );
      _placemarks = await geo.placemarkFromCoordinates(_currentLocation.latitude, _currentLocation.longitude);
      LogDebugger.instance.e(_placemarks.toList());
    } catch (e) {
      LogDebugger.instance.d('Could not get the location: $e');
    }

    return _placemarks;
  }
}