  class UserLocation {
  final double latitude;
  final double longitude;
  final String fullAddress;   // "12 Allen Avenue, Ikeja, Lagos"
  final String street;        // "12 Allen Avenue"
  final String city;          // "Ikeja"
  final String state;         // "Lagos"
  final String country;       // "Nigeria"
  final String postalCode;    // "100001"
 
  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });
 
  @override
  String toString() => fullAddress;
}