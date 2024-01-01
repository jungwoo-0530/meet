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

  int myLookId = -1;
  String myHat = "";
  String myTop = "";
  String myBottom = "";
  String myShoes = "";
  String myEtc = "";
  String myOuter = "";

  int otherLookId = -1;
  String otherHat = "";
  String otherTop = "";
  String otherBottom = "";
  String otherShoes = "";
  String otherEtc = "";
  String otherOuter = "";

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
    required this.myLookId,
    required this.myHat,
    required this.myTop,
    required this.myBottom,
    required this.myShoes,
    required this.myEtc,
    required this.myOuter,
    required this.otherLookId,
    required this.otherHat,
    required this.otherTop,
    required this.otherBottom,
    required this.otherShoes,
    required this.otherEtc,
    required this.otherOuter,
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
        myLookId: json['myLookId'] ?? -1,
        myHat: json['myHat'] ?? "",
        myTop: json['myTop'] ?? "",
        myBottom: json['myBottom'] ?? "",
        myShoes: json['myShoes'] ?? "",
        myEtc: json['myEtc'] ?? "",
        myOuter: json['myOuter'] ?? "",
        otherLookId: json['otherLookId'] ?? -1,
        otherHat: json['otherHat'] ?? "",
        otherTop: json['otherTop'] ?? "",
        otherBottom: json['otherBottom'] ?? "",
        otherShoes: json['otherShoes'] ?? "",
        otherEtc: json['otherEtc'] ?? "",
        otherOuter: json['otherOuter'] ?? "",
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
        myLookId: -1,
        myHat: "",
        myTop: "",
        myBottom: "",
        myShoes: "",
        myEtc: "",
        myOuter: "",
        otherLookId: -1,
        otherHat: "",
        otherTop: "",
        otherBottom: "",
        otherShoes: "",
        otherEtc: "",
        otherOuter: "",
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

class Look {
  int lookId = -1;

  // int locationId = -1;
  String hat = "";
  String outer = "";
  String top = "";
  String bottom = "";
  String shoes = "";
  String etc = "";

  Look.empty();

  Look({
    required this.lookId,
    // required this.locationId,
    required this.hat,
    required this.outer,
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.etc,
  });

  factory Look.fromJson(Map<String, dynamic> json) {
    try {
      return Look(
        lookId: json['id'] ?? -1,
        // locationId: json['locationId'] ?? -1,
        hat: json['hat'] ?? "",
        outer: json['outer'] ?? "",
        top: json['top'] ?? "",
        bottom: json['bottom'] ?? "",
        shoes: json['shoes'] ?? "",
        etc: json['etc'] ?? "",
      );
    } catch (e) {
      meetlog(e.toString());
      return Look.empty();
    }
  }
}
