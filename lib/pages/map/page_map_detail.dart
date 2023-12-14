import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/common/constants.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

class DetailMapPage extends StatefulWidget {
  const DetailMapPage({super.key});

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  bool _isLoading = true;

  final Completer<NaverMapController> mapControllerCompleter = Completer();

  // final Completer<GoogleMapController> _controller = Completer();

  // 선유도역 37.537768 126.893816
  static const LatLng destination = LatLng(37.5385534, 126.8943764);

  // 회사 37.538309 126.891753
  static const LatLng mySourceLocation = LatLng(37.5381981, 126.8914915);

  // 국민 은행 37.536169, 126.897411
  static const LatLng someoneSourceLocation = LatLng(37.536169, 126.897411);

  List<LatLng> myPolylineCoordinates = [];
  List<LatLng> someonePolylineCoordinates = [];

  @override
  void initState() {
    // getPolyPoints(mySourceLocation, destination);

    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MeetSubAppBar(
        title: "Map Detail",
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(Consts.marginPage),
                child: NaverMap(
                  onMapReady: (controller) async {
                    // 지도 준비 완료 시 호출되는 콜백 함수

                    final myMarker =
                        NMarker(id: 'my', position: NLatLng(mySourceLocation.latitude, mySourceLocation.longitude));
                    final someoneMarker = NMarker(
                        id: 'someone',
                        position: NLatLng(someoneSourceLocation.latitude, someoneSourceLocation.longitude));

                    final destinationMarker = NMarker(
                      id: 'destination',
                      position: NLatLng(destination.latitude, destination.longitude),
                    );

                    controller.addOverlayAll({myMarker, someoneMarker, destinationMarker});
                    controller.updateCamera(NCameraUpdate.fromCameraPosition(NCameraPosition(
                        target: NLatLng(mySourceLocation.latitude, mySourceLocation.longitude), zoom: 15)));

                    mapControllerCompleter.complete(controller); // Completer에 지도 컨트롤러 완료 신호 전송
                    meetlog("onMapReady");
                  },
                ),
              ), /*Padding(
                padding: EdgeInsets.all(Consts.marginPage),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: destination, zoom: 17),
                  markers: {
                    const Marker(
                      markerId: MarkerId('destination'),
                      position: destination,
                      infoWindow: InfoWindow(title: '선유도역'),
                    ),
                    const Marker(
                      markerId: MarkerId('mySourceLocation'),
                      position: mySourceLocation,
                      infoWindow: InfoWindow(title: '내 시작 위치'),
                    ),
                    const Marker(
                      markerId: MarkerId('someoneSourceLocation'),
                      position: someoneSourceLocation,
                      infoWindow: InfoWindow(title: '상대방 시작 위치'),
                    ),
                  },
                  polylines: {
                    // Polyline(
                    //   polylineId: const PolylineId('someonePolyline'),
                    //   color: Colors.red,
                    //   points: someonePolylineCoordinates,
                    //   width: 6,
                    // ),
                    Polyline(
                      polylineId: const PolylineId('myPolyline'),
                      color: Colors.blue,
                      points: myPolylineCoordinates,
                      width: 6,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),*/
      ),
    );
  }

  void getPolyPoints(LatLng sourceLocation, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();
    /*PolylineResult result = */ await polylinePoints
        .getRouteBetweenCoordinates(
      dotenv.env['google_map_key']!, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    )
        .then((result) {
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          myPolylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
