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

class LocationDetail {
  int locationId = -1;
  String ownerId = "";
  String otherId = "";

  String ownerLatitude = "";
  String ownerLongitude = "";
  String ownerAddress = "";

  String otherLatitude = "";
  String otherLongitude = "";
  String otherAddress = "";

  String destinationLatitude = "";
  String destinationLongitude = "";
  String destinationAddress = "";

  String chatRoomId = "";

  String status = "";

  LocationDetail.empty();

  LocationDetail({
    required this.locationId,
    required this.ownerId,
    required this.otherId,
    required this.ownerLatitude,
    required this.ownerLongitude,
    required this.ownerAddress,
    required this.otherLatitude,
    required this.otherLongitude,
    required this.otherAddress,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationAddress,
    required this.chatRoomId,
    required this.status,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) {
    try {
      return LocationDetail(
        locationId: json['id'] ?? -1,
        ownerId: json['ownerId'] ?? "",
        otherId: json['otherId'] ?? "",
        ownerLatitude: json['ownerLatitude'] ?? "",
        ownerLongitude: json['ownerLongitude'] ?? "",
        ownerAddress: json['ownerAddress'] ?? "",
        otherLatitude: json['otherLatitude'] ?? "",
        otherLongitude: json['otherLongitude'] ?? "",
        otherAddress: json['otherAddress'] ?? "",
        destinationLatitude: json['destinationLatitude'] ?? "",
        destinationLongitude: json['destinationLongitude'] ?? "",
        destinationAddress: json['destinationAddress'] ?? "",
        chatRoomId: json['chatRoomId'] ?? "",
        status: json['status'] ?? "",
      );
    } catch (e) {
      meetlog(e.toString());
      return LocationDetail(
        locationId: -1,
        ownerId: "",
        otherId: "",
        ownerLatitude: "",
        ownerLongitude: "",
        ownerAddress: "",
        otherLatitude: "",
        otherLongitude: "",
        otherAddress: "",
        destinationLatitude: "",
        destinationLongitude: "",
        destinationAddress: "",
        chatRoomId: "",
        status: "",
      );
    }
  }
}

class InviteInfo {
  int inviteId = -1;
  int locationId = -1;
  String inviteeId = "";
  String inviterId = "";
  String chatRoomId = "";

  InviteInfo.empty();

  InviteInfo({
    required this.inviteId,
    required this.locationId,
    required this.inviteeId,
    required this.inviterId,
    required this.chatRoomId,
  });

  factory InviteInfo.fromJson(Map<String, dynamic> json) {
    try {
      return InviteInfo(
        inviteId: json['id'] ?? -1,
        locationId: json['locationId'] ?? -1,
        inviteeId: json['inviteeId'] ?? "",
        inviterId: json['inviterId'] ?? "",
        chatRoomId: json['chatRoomId'] ?? "",
      );
    } catch (e) {
      meetlog(e.toString());
      return InviteInfo.empty();
    }
  }
}
