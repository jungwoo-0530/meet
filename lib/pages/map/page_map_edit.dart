import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ya_meet/common/constants.dart';
import 'package:ya_meet/custom/meet_button.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

import '../../common/api.dart';
import '../../common/common.dart';
import '../../common/routes.dart';
import '../../common/urls.dart';

class EditMapPage extends StatefulWidget {
  const EditMapPage({super.key});

  @override
  State<EditMapPage> createState() => _EditMapPageState();
}

class _EditMapPageState extends State<EditMapPage> {
  bool _isLoading = true;

  final TextEditingController phoneEditingController = TextEditingController();
  final TextEditingController joinAddressEditingController = TextEditingController();

  String phoneNumber = "";
  String joinAddress = "";
  late NLatLng joinLatLng;

  String myAddress = "";
  late NLatLng myLatLng;

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
                          Text(
                            "내 위치",
                            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "상대방 핸드폰 번호",
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
                              controller: phoneEditingController,
                              autofocus: false,
                              canRequestFocus: true,
                              enabled: true,
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
                                hintText: "상대방 핸드폰 번호를 입력해주세요.",
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
                                    joinAddress = returnData['address']!;
                                    joinAddressEditingController.text = returnData['address']!;
                                    joinLatLng = returnData['NLatLng']!;
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
                                    joinAddress = value;
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
                      enabled: joinAddress.isNotEmpty && phoneNumber.isNotEmpty,
                      onPressed: () {
                        //TODO: 등록 API 호출
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> apiAddress() async {
    await API.callNaverApi(
      URLS.naverReverseGeoCoding,
      parameters: {'coords': '${myLatLng.longitude},${myLatLng.latitude}', 'output': "json"},
      onSuccess: (successData) {
        if (successData['status'] == 'OK') {
          meetlog(successData['results'][0]['region']['area1']['name']);
        }
        setState(() {});
      },
    );
  }

  Future<void> getLocationData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // Location location = Location();
    // await location.getCurrentLocation();
    // meetlog(location.latitude);
    // meetlog(location.longitude);
    meetlog(position.toString());
  }
}
