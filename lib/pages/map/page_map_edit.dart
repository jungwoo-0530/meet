import 'package:flutter/material.dart';
// import 'package:flutter_naver_mtter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ya_meet/common/constants.dart';
import 'package:ya_meet/custom/meet_button.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

import '../../common/api.dart';
import '../../common/common.dart';
import '../../common/meet.dart';
import '../../common/routes.dart';
import '../../common/urls.dart';

class EditMapPage extends StatefulWidget {
  const EditMapPage({super.key});

  @override
  State<EditMapPage> createState() => _EditMapPageState();
}

class _EditMapPageState extends State<EditMapPage> {
  bool _isLoading = true;

  final TextEditingController otherLoginIdEditingController = TextEditingController();
  final TextEditingController joinAddressEditingController = TextEditingController();

  String phoneNumber = "";
  String destinationAddress = "";
  late LatLng destinationLatLng;

  String myAddress = "";
  late LatLng myLatLng;

  @override
  void initState() {
    getLocationData().then((value) {
      _isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MeetSubAppBar(
        title: "등록",
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(Consts.marginPage, 30.h, Consts.marginPage, 30.h),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Text(
                                "내 위치",
                                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              InkWell(
                                onTap: () {
                                  // 현재 위치 좌표, 주소 가져오기
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  getLocationData().then((value) {
                                    apiAddress().then((value) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    });
                                    // setState(() {});
                                  });
                                },
                                child: const Icon(Icons.location_searching),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            myAddress,
                            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "상대방 아이디",
                            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            height: 90.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: TextField(
                              controller: otherLoginIdEditingController,
                              autofocus: false,
                              canRequestFocus: true,
                              enabled: true,
                              keyboardType: TextInputType.name,
                              maxLength: 20,
                              style: TextStyle(
                                color: const Color(0xff222222),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                                decorationThickness: 0,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "상대방 아이디를 입력해주세요.",
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: "",
                                hintStyle: TextStyle(
                                  color: const Color(0xff999999),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                isCollapsed: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  phoneNumber = value;
                                });
                              },
                              onSubmitted: (value) {},
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "만날 장소",
                            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InkWell(
                            onTap: () async {
                              await Navigator.pushNamed(context, ROUTES.MAP_SEARCH).then((result) {
                                if (result != null) {
                                  Map<String, dynamic> returnData = result as Map<String, dynamic>;
                                  setState(() {
                                    destinationAddress = returnData['address']!;
                                    joinAddressEditingController.text = returnData['address']!;
                                    destinationLatLng = returnData['LatLng']!;
                                  });
                                }
                              });
                            },
                            child: Container(
                              height: 90.h,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: TextField(
                                controller: joinAddressEditingController,
                                autofocus: false,
                                canRequestFocus: true,
                                enabled: false,
                                keyboardType: TextInputType.phone,
                                maxLength: 20,
                                style: TextStyle(
                                  color: const Color(0xff222222),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                  decorationThickness: 0,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: "주소를 입력해주세요.",
                                  border: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  counterText: "",
                                  hintStyle: TextStyle(
                                    color: const Color(0xff999999),
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  isCollapsed: true,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    destinationAddress = value;
                                  });
                                },
                                onSubmitted: (value) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MeetButton(
                      radius: 32.r,
                      title: "등록",
                      enabled: destinationAddress.isNotEmpty,
                      onPressed: () {
                        //TODO: 등록 API 호출
                        apiAddMap();
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> apiAddress() async {
    await API.callGoogleApi(URLS.googleReverseGeoCoding, parameters: {
      'latlng': '${myLatLng.latitude},${myLatLng.longitude}',
    }, onSuccess: (successData) {
      String status = successData['status'];
      if (status == 'OK') {
        if (successData['results'].length > 0) {
          String address = successData['results'][0]['formatted_address'];
          myAddress = address.replaceAll("대한민국 ", "");
        }
      } else if (status == "ZERO_RESULTS") {
        myAddress = "주소를 찾을 수 없습니다.";
      } else {
        myAddress = "서버 에러...";
      }
      setState(() {});
    });
  }

  Future<void> getLocationData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    myLatLng = LatLng(position.latitude, position.longitude);
    meetlog(position.latitude.toString());
    meetlog(position.longitude.toString());
  }

  Future<void> apiAddMap() async {
    await API.callPostApi(
      URLS.addMap,
      parameters: {
        'myLoginId': Meet.user.loginId,
        'otherLoginId': otherLoginIdEditingController.text,
        'ownerLatitude': myLatLng.latitude.toString(),
        'ownerLongitude': myLatLng.longitude.toString(),
        'ownerAddress': myAddress,
        'destinationLatitude': destinationLatLng.latitude.toString(),
        'destinationLongitude': destinationLatLng.longitude.toString(),
        'destinationAddress': destinationAddress,
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          Meet.alert(context, "알림", successData['message']).then((value) {
            Navigator.pop(context);
          });
        }
      },
      onFail: (errorData) {},
    );
  }
}
