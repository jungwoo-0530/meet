import 'package:geolocator/geolocator.dart';
import 'package:ya_meet/common/common.dart';

class Address {
  String roadAddress = "";
  String jibunAddress = "";
  String latitude = ""; // 이용문의 : U,제품 문의 P
  String longitude = "";

  Address.empty();

  Address({
    required this.roadAddress,
    required this.jibunAddress,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        roadAddress: json['roadAddress'] ?? "",
        jibunAddress: json['jibunAddress'] ?? "",
        latitude: json['y'] ?? "",
        longitude: json['x'] ?? "",
      );
    } catch (e) {
      meetlog(e.toString());
      return Address.empty();
    }
  }
}

class Location {
  double latitude = 0;
  double longitude = 0;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    // print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      meetlog(e.toString());
    }
  }
}
