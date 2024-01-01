import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ya_meet/common/constants.dart';
import 'package:ya_meet/custom/meet_button.dart';
import 'package:ya_meet/custom/sub_appbar.dart';
import 'package:ya_meet/pages/chat/do.dart';

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

  final TextEditingController myAddressEditingController = TextEditingController();
  final TextEditingController otherLoginIdEditingController = TextEditingController();
  final TextEditingController joinAddressEditingController = TextEditingController();

  final TextEditingController hatEditingController = TextEditingController();
  final TextEditingController outerEditingController = TextEditingController();
  final TextEditingController topEditingController = TextEditingController();
  final TextEditingController bottomEditingController = TextEditingController();
  final TextEditingController shoesEditingController = TextEditingController();
  final TextEditingController etcEditingController = TextEditingController();
  final TextEditingController detailLocationEditingController = TextEditingController();

  String phoneNumber = "";
  String destinationAddress = "";
  late LatLng destinationLatLng;

  String myAddress = "";
  late LatLng myLatLng;

  @override
  void initState() {
    getLocationData().then((value) {
      apiAddress().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                                    });
                                  },
                                  child: const Icon(Icons.location_searching),
                                ),
                              ],
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
                                controller: myAddressEditingController,
                                autofocus: false,
                                canRequestFocus: true,
                                enabled: false,
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
                                  hintText: "내 위치 *",
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
                                onChanged: (value) {},
                                onSubmitted: (value) {},
                              ),
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
                                  hintText: "상대방 아이디 *",
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
                              "만날 위치",
                              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            InkWell(
                              onTap: () async {
                                dynamic result = await Navigator.pushNamed(context, ROUTES.MAP_SEARCH);

                                if (result == null) return;

                                Map<String, dynamic> returnData = result as Map<String, dynamic>;
                                setState(() {
                                  destinationAddress = returnData['address']!;
                                  joinAddressEditingController.text = returnData['address']!;
                                  destinationLatLng = returnData['LatLng']!;
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
                                    hintText: "만날 위치 *",
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
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              "상세 위치",
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
                                controller: detailLocationEditingController,
                                autofocus: false,
                                canRequestFocus: true,
                                enabled: true,
                                keyboardType: TextInputType.name,
                                maxLength: 30,
                                style: TextStyle(
                                  color: const Color(0xff222222),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                  decorationThickness: 0,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: "만날 장소에 대한 자세한 내용을 적어주세요.",
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
                                  });
                                },
                                onSubmitted: (value) {},
                              ),
                            ),
                            ExpansionTile(
                              title: Text(
                                "나의 인상 착의",
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              initiallyExpanded: false,
                              collapsedTextColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              iconColor: Colors.black,
                              shape: const Border(),
                              tilePadding: EdgeInsets.zero,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(flex: 2, child: Text("머리")),
                                    Flexible(
                                      flex: 14,
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
                                          controller: hatEditingController,
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
                                            hintText: "모자 종류, 색상",
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
                                          onChanged: (value) {},
                                          onSubmitted: (value) {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(
                                      flex: 2,
                                      child: Text(
                                        "아우터",
                                      ),
                                    ),
                                    Flexible(
                                      flex: 14,
                                      fit: FlexFit.tight,
                                      child: Container(
                                        height: 90.h,
                                        width: double.infinity,
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
                                          controller: outerEditingController,
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
                                            hintText: "아우터 종류, 색상",
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
                                          onChanged: (value) {},
                                          onSubmitted: (value) {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(flex: 2, child: Text("상의")),
                                    Flexible(
                                      flex: 14,
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
                                          controller: topEditingController,
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
                                            hintText: "상의 종류, 색상",
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
                                          onChanged: (value) {},
                                          onSubmitted: (value) {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(flex: 2, child: Text("하의")),
                                    Flexible(
                                      flex: 14,
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
                                          controller: bottomEditingController,
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
                                            hintText: "하의 종류, 색상",
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
                                          onChanged: (value) {},
                                          onSubmitted: (value) {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(flex: 2, child: Text("신발")),
                                    Flexible(
                                      flex: 14,
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
                                          controller: shoesEditingController,
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
                                            hintText: "신발 종류, 색상",
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
                                          onChanged: (value) {},
                                          onSubmitted: (value) {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(flex: 2, child: Text("기타")),
                                    Flexible(
                                      flex: 14,
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
                                          controller: etcEditingController,
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
                                            hintText: "안경, 주얼리, 가방 등",
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
                                          onChanged: (value) {},
                                          onSubmitted: (value) {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      MeetButton(
                        radius: 32.r,
                        height: 90.h,
                        title: "등록",
                        enabled: destinationAddress.isNotEmpty,
                        onPressed: () {
                          apiAddMap();
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> apiAddress() async {

    await API.callKaKaoApi(
      URLS.kakaoReverseGeoCoding,
      parameters: {
        'x': "${myLatLng.longitude}",
        'y': "${myLatLng.latitude}",
      },
      onSuccess: (successData) {
        meetlog(successData.toString());
        if (successData['meta']['total_count'] > 0) {
          meetlog(successData['documents'][0]['address']['address_name']);
          myAddress = successData['documents'][0]['address']['address_name'];
          myAddressEditingController.text= myAddress;
        } else {
          Meet.alert(context, "알림", "해당 위치에 일치하는 주소가 없습니다.");
          meetlog("해당 좌표에 일치하는 주소가 없습니다.");
        }
        setState(() {

        });
      },
      onFail: (failData) {
        Meet.alert(context, "알림", "서버 에러");
      },
    );

    /*await API.callGoogleApi(URLS.googleReverseGeoCoding, parameters: {
      'latlng': '${myLatLng.latitude},${myLatLng.longitude}',
    }, onSuccess: (successData) {
      String status = successData['status'];
      if (status == 'OK') {
        if (successData['results'].length > 0) {
          String address = successData['results'][0]['formatted_address'];
          myAddress = address.replaceAll("대한민국 ", "");
          myAddress = myAddress.replaceAll("KR ", "");

          myAddressEditingController.text = myAddress;
        }
      } else if (status == "ZERO_RESULTS") {
        myAddress = "주소를 찾을 수 없습니다.";
      } else {
        myAddress = "서버 에러...";
      }
      setState(() {});
    });*/
  }

  Future<void> getLocationData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    myLatLng = LatLng(position.latitude, position.longitude);
    meetlog(position.latitude.toString());
    meetlog(position.longitude.toString());
  }

  Future<void> apiAddMap() async {
    if (Meet.user.loginId == otherLoginIdEditingController.text) {
      Meet.alert(context, "알림", "상대방 아이디를 본인 아이디로 설정할 수 없습니다.");
      return;
    }

    if (myAddress.isEmpty) {
      Meet.alert(context, "알림", "내 위치를 입력해주세요.");
      return;
    }

    if (otherLoginIdEditingController.text.isEmpty) {
      Meet.alert(context, "알림", "상대방 아이디를 입력해주세요.");
      return;
    }

    if (destinationAddress.isEmpty) {
      Meet.alert(context, "알림", "만날 장소를 입력해주세요.");
      return;
    }

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
        'destinationDetailAddress': detailLocationEditingController.text,
        'hat': hatEditingController.text,
        'outer': outerEditingController.text,
        'top': topEditingController.text,
        'bottom': bottomEditingController.text,
        'shoes': shoesEditingController.text,
        'etc': etcEditingController.text,
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          meetlog(successData['data'].toString());

          Meet.alert(context, "알림", successData['message']).then((value) async {
            // firestore에 저장
            FirebaseFirestore fireStore = FirebaseFirestore.instance;
            await fireStore
                .collection("chat_collection")
                .doc(successData['data']['chatRoomId'].toString())
                .set(ChatFireBase(
                  lastMessage: "",
                  lastUpdateTime: DateTime.now(),
                  users: [Meet.user.loginId, otherLoginIdEditingController.text],
                  status: "W",
                  useYn: "Y",
                  createdUser: Meet.user.loginId,
                ).toJson())
                .then((value) {
              Navigator.pop(context);
            });
          });
        } else {
          Meet.alert(context, "알림", successData['message']);
        }
      },
      onFail: (errorData) {},
    );
  }
}
