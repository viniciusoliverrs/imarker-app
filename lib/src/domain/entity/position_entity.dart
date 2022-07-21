import 'package:latlong2/latlong.dart' as ll;

class PositionEntity {
  final String id;
  final DateTime createdAt;
  final double latitude;
  final double longitude;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String numberStreet;
  final String subLocality;
  PositionEntity({
    required this.id,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.numberStreet,
    required this.subLocality,
  });

  double distanceTo(PositionEntity other) {
    var distance = const ll.Distance();
    final meter = distance(ll.LatLng(latitude, longitude),
        ll.LatLng(other.latitude, other.longitude));
    return meter;
  }

  String address() {
    return "$street, $numberStreet";
  }
}
