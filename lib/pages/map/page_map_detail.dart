import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/common/constants.dart';
import 'package:ya_meet/custom/sub_appbar.dart';
import 'package:ya_meet/pages/map/do.dart';

import '../../common/api.dart';
import '../../common/meet.dart';
import '../../common/urls.dart';

class DetailMapPage extends StatefulWidget {
  const DetailMapPage({super.key, required this.arguments});

  final Map<String, dynamic>? arguments;

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  bool _isLoading = true;

  late LocationDetail locationDetail;

  Location location = Location();

  int myTestPathsIdx = 0;
  int otherTestPathsIdx = 0;
  bool arrivedMyDestination = false;
  bool arrivedOtherDestination = false;

  final Completer<GoogleMapController> _googleCompleterController = Completer();

  // 목적지
  late LatLng destination;

  // 초기 내 위치와 상대 위치.
  late LatLng myFirstLocation;
  late LatLng otherFirstLocation;

  LatLng mySourceLocation = const LatLng(37.5381981, 126.8914915);

  // 국민 은행 37.536169, 126.897411
  LatLng otherSourceLocation = const LatLng(37.536169, 126.897411);

  List<LatLng> myPolylineCoordinates = [];
  List<LatLng> otherPolylineCoordinates = [];

  Set<Marker> markers = {};
  var markerList = [];

  Set<Polyline> polyLines = {};
  int polyLineIdx = 0;
  List<LatLng> myPaths = [];
  List<LatLng> otherPaths = [];

  Timer? markerTimer;
  Timer? polyLineTimer;

  @override
  void initState() {
    apiGetDetail().then((value) {
      apiGetMyPaths().then((value) {
        apiGetOtherLocation().then((value) {
          // 냐의 위치
          location.getCurrentLocation();

          //s: 마커 초기화, 마커 타이머
          markerList.add({
            'id': "me",
            'marker': Marker(
              markerId: const MarkerId('me'),
              position: mySourceLocation,
              infoWindow: const InfoWindow(title: '내 위치'),
              icon: BitmapDescriptor.defaultMarker,
            )
          });
          markerList.add({
            'id': "other",
            'marker': Marker(
              markerId: const MarkerId('other'),
              position: otherSourceLocation,
              infoWindow: const InfoWindow(title: '상대방 위치'),
              icon: BitmapDescriptor.defaultMarker,
            )
          });
          markerList.add({
            'id': "destination",
            'marker': Marker(
              markerId: const MarkerId('destination'),
              position: destination,
              infoWindow: const InfoWindow(title: '목적지'),
              icon: BitmapDescriptor.defaultMarker,
            )
          });

          for (var i = 0; i < markerList.length; i++) {
            markers.add(markerList[i]["marker"]);
          }

          // 3 초마다 현재 위치를 가져와서 마커를 이동시킨다.
          markerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
            // 상대방 위치
            apiGetOtherLocation().then((value) {
              meetlog("마커 타이머");

              meetlog("상대방 위치------");
              meetlog(otherSourceLocation.longitude.toString());
              meetlog(otherSourceLocation.latitude.toString());
              meetlog("상대방 위치------");

              //s: 내위치
              location.getCurrentLocation();
              meetlog("내 위치-----");
              meetlog(location.longitude.toString());
              meetlog(location.latitude.toString());
              meetlog("내 위치-----");

              mySourceLocation = LatLng(location.latitude, location.longitude);
              int index = markerList.indexWhere((item) => item["id"] == "me");

              markerList[index] = {
                "id": "me",
                "marker": Marker(
                    markerId: const MarkerId("me"),
                    position: LatLng(mySourceLocation.latitude, location.longitude), //move to new location
                    icon: BitmapDescriptor.defaultMarker)
              };
              //e: 내위치

              //s: 상대방 위치
              //e: 상대방 위치

              // 마커들 초기화
              markers = {};
              for (var i = 0; i < markerList.length; i++) {
                markers.add(//repopulate markers
                    markerList[i]["marker"]);
              }

              // refresh
              setState(() {});

              // 내 위치 업데이트
              apiUpdateMyLocation();
            });
          });
          //e: 마커 초기화, 마커 타이머

          //s: 폴리라인 타이머
          polyLineTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
            meetlog("폴리라인 타이머");

            polyLines = {};
            polyLineIdx = 0;
            myPaths = [];
            otherPaths = [];
            apiGetMyPaths().then((value) {
              setState(() {
                _isLoading = false;
              });
            });
          });
          //e: 폴리라인 타이머
          setState(() {
            _isLoading = false;
          });
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    markerTimer?.cancel();
    polyLineTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MeetSubAppBar(
        title: "Map Detail",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          meetlog("테스트 fab");
          setState(() {
            _isLoading = true;
          });

          if (myTestPathsIdx < myPaths.length && arrivedMyDestination == false) {
            //s: 내위치 이동
            mySourceLocation = LatLng(myPaths[myTestPathsIdx].latitude, myPaths[myTestPathsIdx].longitude);

            //TODO: 내 위치 업데이트 API 호출

            int index = markerList.indexWhere((item) => item["id"] == "me");

            meetlog('${mySourceLocation.latitude}, ${mySourceLocation.longitude}');

            markerList[index] = {
              "id": "me",
              "marker": Marker(
                  markerId: const MarkerId("me"),
                  position: LatLng(
                      myPaths[myTestPathsIdx].latitude, myPaths[myTestPathsIdx].longitude), //move to new location
                  icon: BitmapDescriptor.defaultMarker)
            };
            //e: 내위치
            myTestPathsIdx++;
          } else {
            if (arrivedMyDestination == false) {
              Meet.alert(context, "알림", "목적지에 도착했습니다.(나)");
              arrivedMyDestination = true;
            }
          }

          if (otherTestPathsIdx < otherPaths.length && arrivedOtherDestination == false) {
            //s: 상대방 위치
            otherSourceLocation =
                LatLng(otherPaths[otherTestPathsIdx].latitude, otherPaths[otherTestPathsIdx].longitude);

            // TODO: 상대방 위치 get api 호출
            int index = markerList.indexWhere((item) => item["id"] == "other");

            meetlog('${otherSourceLocation.latitude}, ${mySourceLocation.longitude}');

            markerList[index] = {
              "id": "other",
              "marker": Marker(
                  markerId: const MarkerId("other"),
                  position: LatLng(otherPaths[otherTestPathsIdx].latitude,
                      otherPaths[otherTestPathsIdx].longitude), //move to new location
                  icon: BitmapDescriptor.defaultMarker)
            };
            //e: 상대방 위치
            otherTestPathsIdx++;
          } else {
            if (arrivedOtherDestination == false) {
              Meet.alert(context, "알림", "목적지에 도착했습니다.(상대방)");
              arrivedOtherDestination = true;
            }
          }

          // 마커들 초기화
          markers = {};
          for (var i = 0; i < markerList.length; i++) {
            markers.add(markerList[i]["marker"]);
          }

          setState(() {
            _isLoading = false;
          });
          //e: 내위치 이동
        },
        child: const Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(Consts.marginPage),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: destination,
                    zoom: 16,
                  ),
                  markers: markers,
                  polylines: polyLines,
                  onMapCreated: (GoogleMapController controller) {
                    meetlog("onMapCreated");
                    _googleCompleterController.complete(controller);

                    // 마커 위치에 따른 줌
                    /*setState(() {
                      controller.animateCamera(CameraUpdate.newLatLngBounds(getBoundary(markers), 50));
                    });*/
                  },
                ),
              ),
      ),
    );
  }

  // 마커 boundary 설정
  LatLngBounds getBoundary(Set<Marker> markers) {
    List<LatLng> positions = markers.map((m) => m.position).toList();

    final southwestLat =
        positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon =
        positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat =
        positions.map((p) => p.latitude).reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon =
        positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);

    return LatLngBounds(southwest: LatLng(southwestLat, southwestLon), northeast: LatLng(northeastLat, northeastLon));
  }

  // polyLine 설정
  void initPolyline(Color color, List<LatLng> targetLocationList) async {
    var locationList = targetLocationList;
    List<LatLng> loc = [];
    if (locationList.isEmpty) return;
    if (locationList.length < 2) return;
    for (int i = 0; i < locationList.length - 1; i++) {
      loc.add(LatLng(locationList[i].latitude, locationList[i].longitude));
    }
    polyLines.add(Polyline(
      polylineId: PolylineId(polyLineIdx.toString()),
      points: loc,
      color: color,
    ));
    polyLineIdx++;
  }

  Future<void> apiGetMyPaths() async {
    await API.callNaverApi(
      URLS.naverDirection15,
      parameters: {
        'start': '${mySourceLocation.longitude},${mySourceLocation.latitude}',
        'goal': '${destination.longitude},${destination.latitude}'
      },
      onSuccess: (successData) {
        if (successData['code'] == 0) {
          myPaths.add(LatLng(mySourceLocation.latitude, mySourceLocation.longitude));

          Map<String, dynamic> result;
          result = successData['route'];
          List guideList = result['traoptimal'][0]['guide'] as List;

          List<int> pathIndex = [];
          for (var element in guideList) {
            var index = element['pointIndex'];
            pathIndex.add(index);
          }

          List trafast = successData['route']['traoptimal'];
          List tempPaths = trafast[0]['path'];
          for (int i = 0; i < tempPaths.length; i++) {
            if (pathIndex.contains(i)) {
              myPaths.add(LatLng(tempPaths[i][1], tempPaths[i][0]));
            }
          }

          initPolyline(Colors.lightBlue, myPaths);
        } else if (successData['code'] == 1) {
          meetlog("도착");
        }
      },
    );
  }

  Future<void> apiGetOtherPaths() async {
    // String start;
    // String goal;

    await API.callNaverApi(
      URLS.naverDirection15,
      parameters: {
        'start': '${otherSourceLocation.longitude},${otherSourceLocation.latitude}',
        'goal': '${destination.longitude},${destination.latitude}'
      },
      onSuccess: (successData) {
        if (successData['code'] == 0) {
          otherPaths.add(LatLng(otherSourceLocation.latitude, otherSourceLocation.longitude));

          Map<String, dynamic> result;
          result = successData['route'];

          List guideList = result['traoptimal'][0]['guide'] as List;

          List<int> pathIndex = [];
          for (var element in guideList) {
            var index = element['pointIndex'];
            pathIndex.add(index);
          }

          List tempPaths = successData['route']['traoptimal'][0]['path'];
          for (int i = 0; i < tempPaths.length; i++) {
            if (pathIndex.contains(i)) {
              otherPaths.add(LatLng(tempPaths[i][1], tempPaths[i][0]));
            }
          }

          initPolyline(Colors.red, otherPaths);
        } else if (successData['code'] == 1) {
          meetlog("도착");
        }
      },
    );
  }

  Future<void> apiGetDetail() async {
    meetlog(widget.arguments!['locationId'].toString());

    await API.callGetApi(
      URLS.getMapDetail,
      parameters: {
        'locationId': widget.arguments!['locationId'].toString(),
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          setState(() {
            locationDetail = LocationDetail.fromJson(successData['data']);

            myFirstLocation =
                LatLng(double.parse(locationDetail.ownerLatitude), double.parse(locationDetail.ownerLongitude));
            otherFirstLocation =
                LatLng(double.parse(locationDetail.otherLatitude), double.parse(locationDetail.otherLongitude));

            destination = LatLng(
                double.parse(locationDetail.destinationLatitude), double.parse(locationDetail.destinationLongitude));
          });
        }
      },
    );
  }

  Future<void> apiGetOtherLocation() async {
    await API.callGetApi(
      URLS.getOtherLocation,
      parameters: {
        'locationId': locationDetail.locationId.toString(),
        'otherLoginId': locationDetail.otherId,
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          setState(() {
            otherSourceLocation =
                LatLng(double.parse(successData['data']['latitude']), double.parse(successData['data']['longitude']));
          });
        }
      },
    );
  }

  Future<void> apiUpdateMyLocation() async {
    await API.callPostApi(
      URLS.updateLocation,
      parameters: {
        'locationId': locationDetail.locationId.toString(),
        'myLoginId': locationDetail.ownerId,
        'ownerLatitude': mySourceLocation.latitude.toString(),
        'ownerLongitude': mySourceLocation.longitude.toString(),
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          setState(() {});
        }
      },
    );
  }
}
