import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:imarker_app/src/domain/entity/position_entity.dart';
import 'package:imarker_app/src/domain/entity/range_entity.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:uuid/uuid.dart';

class GoogleMapsProvider with ChangeNotifier {
  Completer<GoogleMapController> googleMapController = Completer();
  final TextEditingController searchController = TextEditingController();
  List<PositionEntity> positions = [];
  double distanceBetweenMarkers = 0;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  CameraPosition cameraPosition = const CameraPosition(
    bearing: 3,
    target: LatLng(-23.562436, -46.655005),
    zoom: 20,
  );

  void addMarker(LatLng latLng) async {
    List<Placemark> listPracemark =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (listPracemark.isNotEmpty) {
      final String markerId = const Uuid().v4();
      Placemark placemark = listPracemark[0];
      positions.add(PositionEntity(
        id: markerId,
        numberStreet: placemark.name ?? "",
        createdAt: DateTime.now(),
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        street: placemark.street ?? "",
        city: placemark.locality ?? "",
        state: placemark.administrativeArea ?? "",
        country: placemark.country ?? "",
        postalCode: placemark.postalCode ?? "",
        subLocality: placemark.subLocality ?? "",
      ));
      Marker marker = Marker(
          markerId: MarkerId(markerId),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: placemark.street));

      markers.add(marker);
      distanceBetweenMarkers = calculateDistanceBetweenMarkers();
      notifyListeners();

      createPolylines(markers);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController.complete(controller);
  }

  createPolylines(Set<Marker> markers) {
    polylines.add(
      Polyline(
        polylineId: const PolylineId("userPath__1"),
        visible: true,
        points: markers.map((Marker marker) {
          return marker.position;
        }).toList(),
        color: Colors.redAccent,
        width: 1,
        jointType: JointType.mitered,
      ),
    );
    notifyListeners();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var distance = const ll.Distance();
    final meter = distance(ll.LatLng(lat1, lon1), ll.LatLng(lat2, lon2));
    return meter;
  }

  currentPositionListener() async {
    late bool serviceEnabled;
    late LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // var position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        cameraPosition = CameraPosition(
            bearing: 10,
            tilt: 70,
            target: LatLng(position.latitude, position.longitude),
            zoom: 20);

        addMarker(LatLng(position.latitude, position.longitude));
        notifyListeners();
        cameraMove();
      }
    });
  }

  Future<void> cameraMove() async {
    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    notifyListeners();
  }

  removeMarker(MarkerId markerId) {
    markers.removeWhere((Marker marker) => marker.markerId == markerId);
    notifyListeners();
  }

  calculateDistanceBetweenMarkers() {
    if (positions.isEmpty) return;
    double distance = 0;

    for (int i = 1; i < positions.length; i++) {
      distance += calculateDistance(
          positions[i - 1].latitude,
          positions[i - 1].longitude,
          positions[i].latitude,
          positions[i].longitude);
    }
    return distance;
  }

  List<RangeEntity> getRanges() {
    List<RangeEntity> ranges = [];
    if (positions.isEmpty) return ranges;
    for (int i = 1; i < positions.length; i++) {
      ranges.add(RangeEntity.fromPositions(
        start: positions[i - 1],
        end: positions[i],
      ));
    }
    return ranges;
  }

  void closePointsOnMap() {
    addMarker(markers.first.position);
  }

  void clearMap() {
    markers.clear();
    polylines.clear();
    positions.clear();
    distanceBetweenMarkers = 0;
    notifyListeners();
  }
}
