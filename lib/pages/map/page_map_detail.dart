import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/custom/sub_appbar.dart';
import 'package:ya_meet/pages/map/do.dart';

import '../../common/api.dart';
import '../../common/meet.dart';
import '../../common/routes.dart';
import '../../common/urls.dart';

class DetailMapPage extends StatefulWidget {
  const DetailMapPage({super.key, required this.arguments});

  final Map<String, dynamic>? arguments;

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  bool _isLoading = true;

  String? title;

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

  late LatLng mySourceLocation;
  late LatLng otherSourceLocation;

  Set<Marker> markers = {};
  var markerList = [];

  Set<Polyline> polyLines = {};
  int polyLineIdx = 0;
  List<LatLng> myPaths = [];
  List<LatLng> otherPaths = [];

  int myTestPathCnt = 0; // 테스트용
  int otherTestPathCnt = 0; // 테스트용
  int myTestPathIdx = 0;
  int otherTestPathIdx = 0;

  Timer? markerTimer;
  Timer? polyLineTimer;

  //chat
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> chatStream;

  @override
  void initState() {
    apiGetDetail().then((value) {
      chatStream = fireStore
          .collection("chat_collection")
          .doc(locationDetail.chatRoomId)
          .collection("messages")
          .where('sender', isNotEqualTo: Meet.user.loginId)
          .where('readYn', isEqualTo: 'N')
          .snapshots();

      apiGetMyPaths().then((value) {
        apiGetOtherLocation().then((value) {
          apiGetOtherPaths().then((value) {
            // 냐의 위치
            location.getCurrentLocation();

            generateMaker();

            setTimer();

            setState(() {
              _isLoading = false;
            });
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
    // TODO : title 수정
    return Scaffold(
      appBar: MeetSubAppBar(
        title: widget.arguments?['title'].toString(),
        actions: [
          InkWell(
            onTap: () {
              meetlog("대화방으로 이동");
              String otherId =
                  locationDetail.ownerId == Meet.user.loginId ? locationDetail.otherId : locationDetail.ownerId;
              Navigator.pushNamed(context, ROUTES.CHAT_EDIT, arguments: {
                'chatRoomId': locationDetail.chatRoomId,
                'otherId': otherId,
              });
            },
            child: _isLoading
                ? Container()
                : StreamBuilder<QuerySnapshot>(
                    stream: chatStream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: 70.w,
                          padding: EdgeInsets.only(right: 20.w),
                          child: Stack(
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.message),
                              ),
                              if (snapshot.data!.docs.isNotEmpty)
                                Positioned(
                                  right: 0.w,
                                  top: 20.h,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 5.0,
                                      height: 5.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
          ),
          InkWell(
            onTap: () {
              meetlog("인상착의, 정보 모달창 열기");
              Navigator.pushNamed(context, ROUTES.MAP_INFO, arguments: {
                'locationId': locationDetail.locationId,
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: const Icon(Icons.info_outline),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          meetlog("테스트 fab");

          // 1. 현재 내 위치 가져오기
          // 2. 내 위치 업데이트(api 서버로 업데이트)
          // 3. 새로운 경로 가져오기(api 호출)
          // 5. 마커 이동.
          // 4. poliline 그리기.

          myPaths.removeAt(0);
          otherPaths.removeAt(0);

          // 1. 현재 내 위치 가져오기
          mySourceLocation = myPaths[0];
          otherSourceLocation = otherPaths[0];

          // 3. 새로운 경로 가져오기
          polyLines = {};
          polyLineIdx = 0;

          initPolyline(Colors.lightBlue, myPaths);
          initPolyline(Colors.red, otherPaths);

          generateMaker();

          setState(() {});
        },

        child: const Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                // padding: EdgeInsets.all(Consts.marginPage),
                padding: EdgeInsets.zero,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: destination,
                    zoom: 14,
                  ),
                  markers: markers,
                  polylines: polyLines,
                  cameraTargetBounds: CameraTargetBounds(getBoundary(markers)),
                  myLocationButtonEnabled: false,
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
  void initPolyline(Color color, List<LatLng> targetLocationList) {
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
          myPaths = [];

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
            // if (pathIndex.contains(i)) {
            myPaths.add(LatLng(tempPaths[i][1], tempPaths[i][0]));
            // }
          }

          myTestPathCnt = myPaths.length;

          initPolyline(Colors.lightBlue, myPaths);
        } else if (successData['code'] == 1) {
          meetlog("도착");
        }
      },
    );
  }

  Future<void> apiGetOtherPaths() async {
    await API.callNaverApi(
      URLS.naverDirection15,
      parameters: {
        'start': '${otherSourceLocation.longitude},${otherSourceLocation.latitude}',
        'goal': '${destination.longitude},${destination.latitude}'
      },
      onSuccess: (successData) {
        if (successData['code'] == 0) {
          otherPaths = [];

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
            // if (pathIndex.contains(i)) {
            otherPaths.add(LatLng(tempPaths[i][1], tempPaths[i][0]));
            // }
          }

          otherTestPathCnt = otherPaths.length;

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
        'loginId': Meet.user.loginId.toString(),
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          setState(() {
            locationDetail = LocationDetail.fromJson(successData['data']);

            mySourceLocation =
                LatLng(double.parse(successData['data']['currentMyLatitude']), double.parse(successData['data']['currentMyLongitude']));
            otherSourceLocation =
                LatLng(double.parse(successData['data']['currentOtherLatitude']), double.parse(successData['data']['currentOtherLongitude']));
            if (locationDetail.ownerId == Meet.user.loginId) {
              meetlog("내 위치");
              myFirstLocation =
                  LatLng(double.parse(locationDetail.ownerLatitude), double.parse(locationDetail.ownerLongitude));
              otherFirstLocation =
                  LatLng(double.parse(locationDetail.otherLatitude), double.parse(locationDetail.otherLongitude));

              /*mySourceLocation =
                  LatLng(double.parse(locationDetail.ownerLatitude), double.parse(locationDetail.ownerLongitude));
              otherSourceLocation =
                  LatLng(double.parse(locationDetail.otherLatitude), double.parse(locationDetail.otherLongitude));*/
            } else {
              meetlog("상대방 위치");
              myFirstLocation =
                  LatLng(double.parse(locationDetail.otherLatitude), double.parse(locationDetail.otherLongitude));
              otherFirstLocation =
                  LatLng(double.parse(locationDetail.ownerLatitude), double.parse(locationDetail.ownerLongitude));

              /*mySourceLocation =
                  LatLng(double.parse(locationDetail.otherLatitude), double.parse(locationDetail.otherLongitude));
              otherSourceLocation =
                  LatLng(double.parse(locationDetail.ownerLatitude), double.parse(locationDetail.ownerLongitude));*/
            }

            destination = LatLng(
                double.parse(locationDetail.destinationLatitude), double.parse(locationDetail.destinationLongitude));
          });
        }
      },
    );
  }

  // 타이머 생성
  // 1. 현재 내 위치 가져오기
  // 2. 내 위치 업데이트(api 서버로 업데이트)
  // 3. 새로운 경로 가져오기(api 호출)
  // 5. 마커 이동.
  // 4. poliline 그리기.
  void setTimer() {
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
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue))
        };
        //e: 내위치

        generateMaker();

        /*// 마커들 초기화
        markers = {};
        for (var i = 0; i < markerList.length; i++) {
          markers.add(//repopulate markers
              markerList[i]["marker"]);
        }*/
        // refresh
        setState(() {});

        // 내 위치 업데이트
        // apiUpdateMyLocation();
      });
    });
    //e: 마커 초기화, 마커 타이머

    //s: 폴리라인 타이머
    polyLineTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      meetlog("폴리라인 타이머");

      polyLines = {};
      polyLineIdx = 0;
      // myPaths = [];
      // otherPaths = [];

      apiGetMyPaths().then((value) {
        apiGetOtherPaths().then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    });
    //e: 폴리라인 타이머
  }

  // 마커 생성
  void generateMaker() {
    markerList = [];
    markers = {};

    //s: 마커 초기화, 마커 타이머
    markerList.add({
      'id': "me",
      'marker': Marker(
        markerId: const MarkerId('me'),
        position: mySourceLocation,
        infoWindow: const InfoWindow(title: '내 위치'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      )
    });
    markerList.add({
      'id': "other",
      'marker': Marker(
        markerId: const MarkerId('other'),
        position: otherSourceLocation,
        infoWindow: const InfoWindow(title: '상대방 위치'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      )
    });
    markerList.add({
      'id': "destination",
      'marker': Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        infoWindow: const InfoWindow(title: '목적지'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      )
    });

    for (var i = 0; i < markerList.length; i++) {
      markers.add(markerList[i]["marker"]);
    }
  }

  /////// API
  Future<void> apiGetOtherLocation() async {
    String otherLoginId = locationDetail.ownerId == Meet.user.loginId ? locationDetail.otherId : locationDetail.ownerId;

    await API.callGetApi(
      URLS.getOtherLocation,
      parameters: {
        'locationId': locationDetail.locationId.toString(),
        'otherLoginId': otherLoginId,
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
}
