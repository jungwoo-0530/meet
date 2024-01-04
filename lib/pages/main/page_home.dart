import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ya_meet/custom/meet_button.dart';

import '../../common/api.dart';
import '../../common/common.dart';
import '../../common/constants.dart';
import '../../common/meet.dart';
import '../../common/routes.dart';
import '../../common/urls.dart';
import '../map/do.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  List<InviteInfo> inviteList = [];

  @override
  void initState() {
    apiGetInviteList().then((value) {
      setState(() {
        _isLoading = false;

        if (inviteList.isNotEmpty) {
          // callInvite(inviteList.first, context);
          inviteModel(inviteList.first, context);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: Meet.user.loginId,
                        style: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: "님 안녕하세요!",
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                /*Container(
                  height: 400.h,
                  padding: EdgeInsets.all(Consts.marginPage),
                  color: Colors.grey,
                  width: double.infinity,
                  child: const Center(child: Text("프로필"))),
              SizedBox(
                height: 30.h,
              ),
              Container(
                color: Colors.blue,
                height: 200.h,
                width: double.infinity,
                child: const Center(child: Text("공지")),
              ),*/
                /*SizedBox(
                height: 30.h,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ROUTES.LOGIN);
                },
                child: const Text("로그인"),
              ),
              SizedBox(
                height: 30.h,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ROUTES.JOIN);
                },
                child: const Text("회원가입"),
              ),*/
              ],
            ),
    );
  }

  Future<void> apiGetInviteList() async {
    await API.callGetApi(
      URLS.getInviteList,
      parameters: {'id': Meet.user.loginId},
      onSuccess: (successData) {
        if (successData['status'] == '200') {
          if (successData['count'] > 0) {
            List<dynamic> list = successData['data'];
            for (int i = 0; i < list.length; i++) {
              inviteList.add(InviteInfo.fromJson(list[i]));
            }
          }
        } else {
          meetlog("error : ${successData['message']}");
        }
      },
      onFail: (failData) {},
    );
  }

  void inviteModel(InviteInfo info, BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
      ),
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 0),
            child: Wrap(
              // mainAxisSize: MainAxisSize.min,
              spacing: 60.w,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "초대",
                    style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: info.inviterId,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: "님이 초대하였습니다.",
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                      children: const [
                        TextSpan(
                          text: "수락할 경우 서로의 위치가 공유됩니다.",
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                      children: const [
                        TextSpan(
                          text: "상대방 위치",
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '- ${info.inviterAddress}',
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                      children: const [
                        TextSpan(
                          text: "목적지",
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '- ${info.destinationAddress}',
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                if (info.destinationAddressDetail.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text.rich(
                      TextSpan(
                        children: const [
                          TextSpan(
                            text: "상세 위치",
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '- ${info.destinationAddressDetail}',
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
                Row(
                  children: [
                    Expanded(
                      child: MeetButton(
                        height: 100.h,
                        // width: 200.w,
                        radius: 16.r,
                        enabled: true,
                        backgroundColor: Colors.white,
                        borderColor: Consts.primaryColor,
                        borderWidth: 2.w,
                        titleColor: Consts.primaryColor,
                        onPressed: () async {
                          // 거절
                          await API.callPostApi(
                            URLS.acceptInvite,
                            parameters: {
                              'id': info.inviteId.toString(),
                              'locationId': info.locationId.toString(),
                              'status': "N",
                            },
                            onSuccess: (successData) {
                              Meet.alert(context, "알림", "거절되었습니다.").then((value) {
                                Navigator.pop(context);

                                inviteList.removeAt(0);

                                if (inviteList.isNotEmpty) {
                                  inviteModel(inviteList.first, context);
                                }
                              });
                            },
                            onFail: (failData) {},
                          );
                        },
                        title: "거절",
                      ),
                    ),
                    SizedBox(
                      width: 36.w,
                    ),
                    Expanded(
                      child: MeetButton(
                        height: 90.h,
                        radius: 16.r,
                        enabled: true,
                        backgroundColor: Consts.primaryColor,
                        onPressed: () async {
                          // 수락

                          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                              .then((position) async {
                            // LatLng latLng;
                            String address = "";
                            LatLng latLng = LatLng(position.latitude, position.longitude);
                            await API.callKaKaoApi(
                              URLS.kakaoReverseGeoCoding,
                              parameters: {
                                'x': "${latLng.longitude}",
                                'y': "${latLng.latitude}",
                              },
                              onSuccess: (successData) {
                                Navigator.pop(context);
                                if (successData['meta']['total_count'] > 0) {
                                  meetlog(successData['documents'][0]['address']['address_name']);
                                  address = successData['documents'][0]['address']['address_name'];

                                  inviteInfoModal(info, address, latLng, context);
                                } else {
                                  Meet.alert(context, "알림", "해당 위치에 일치하는 주소가 없습니다.");
                                  meetlog("해당 좌표에 일치하는 주소가 없습니다.");
                                }
                              },
                              onFail: (failData) {
                                Meet.alert(context, "알림", "서버 에러");
                              },
                            );
                          });
                        },
                        title: "수락",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> inviteInfoModal(InviteInfo info, String initAddress, LatLng initLatLng, BuildContext context) async {
    String address = initAddress;
    LatLng latLng = initLatLng;

    final TextEditingController hatEditingController = TextEditingController();
    final TextEditingController outerEditingController = TextEditingController();
    final TextEditingController topEditingController = TextEditingController();
    final TextEditingController bottomEditingController = TextEditingController();
    final TextEditingController shoesEditingController = TextEditingController();
    final TextEditingController etcEditingController = TextEditingController();

    meetlog(info.destinationAddress);
    meetlog(info.destinationAddressDetail);
    meetlog(info.inviterAddress);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter bottomState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                // padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 0),
                  child: Wrap(
                    // crossAxisAlignment: WrapCrossAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    spacing: 60.w,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "초대",
                          style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text.rich(
                          TextSpan(
                            children: const [
                              TextSpan(
                                text: "초대를 수락하려면 다음 내용이 필요합니다.",
                              ),
                            ],
                            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
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
                            onTap: () async {
                              Position position =
                                  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                              // latLng = LatLng(position.latitude, position.longitude);

                              // 테스트 당산역
                              latLng = const LatLng(37.533415, 126.902984);

                              await API.callKaKaoApi(
                                URLS.kakaoReverseGeoCoding,
                                parameters: {
                                  'x': "${latLng?.longitude}",
                                  'y': "${latLng?.latitude}",
                                },
                                onSuccess: (successData) {
                                  meetlog(successData.toString());
                                  if (successData['meta']['total_count'] > 0) {
                                    meetlog(successData['documents'][0]['address']['address_name']);
                                    address = successData['documents'][0]['address']['address_name'];
                                  } else {
                                    Meet.alert(context, "알림", "해당 위치에 일치하는 주소가 없습니다.");
                                    meetlog("해당 좌표에 일치하는 주소가 없습니다.");
                                  }

                                  bottomState(() {
                                    setState(() {});
                                  });
                                },
                                onFail: (failData) {
                                  Meet.alert(context, "알림", "서버 에러");
                                },
                              );

                              /*await API.callGoogleApi(URLS.googleReverseGeoCoding, parameters: {
                                'latlng': '${latLng?.latitude},${latLng?.longitude}',
                                // 'latlng': '37.2779594830596,127.03896078343',
                              }, onSuccess: (successData) {
                                String status = successData['status'];
                                if (status == 'OK') {
                                  if (successData['results'].length > 0) {
                                    String tempAddress = successData['results'][0]['formatted_address'];
                                    address = tempAddress.replaceAll("대한민국 ", "");
                                    address = address.replaceAll("KR ", "");
                                  }
                                } else if (status == "ZERO_RESULTS") {
                                  Meet.alert(context, "알림", "주소를 찾을 수 없습니다.");
                                } else {
                                  Meet.alert(context, "알림", "서버 에러");
                                }

                                bottomState(() {
                                  setState(() {});
                                });
                              });*/
                            },
                            child: const Icon(Icons.location_searching),
                          ),
                        ],
                      ),
                      if (address.isNotEmpty) ...[
                        SizedBox(
                          height: 25.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        )
                      ] else ...[
                        SizedBox(
                          height: 40.h,
                        ),
                      ],
                      ExpansionTile(
                        title: Align(
                          alignment: Alignment.topLeft,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "나의 인상 착의",
                                  style: TextStyle(
                                    color: const Color(0xff222222),
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: "(선택)",
                                  style: TextStyle(
                                    color: const Color(0xff999999),
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        initiallyExpanded: true,
                        collapsedTextColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        iconColor: Colors.black,
                        shape: const Border(),
                        tilePadding: EdgeInsets.zero,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(flex: 2, child: Text("모자")),
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
                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MeetButton(
                              radius: 32.r,
                              height: 90.h,
                              title: "확인",
                              onPressed: () async {
                                if (latLng == null) {
                                  return;
                                }

                                await API.callPostApi(
                                  URLS.acceptInvite,
                                  parameters: {
                                    'id': info.inviteId.toString(),
                                    'locationId': info.locationId.toString(),
                                    'inviteeLatitude': "${latLng?.latitude}",
                                    // 'inviteeLatitude': "37.273536",
                                    'inviteeLongitude': "${latLng?.longitude}",
                                    // 'inviteeLongitude': "127.036567",
                                    'inviteeAddress': address,
                                    // 'inviteeAddress': "아주대",
                                    'inviteeId': Meet.user.loginId,
                                    'status': "Y",
                                    'hat': hatEditingController.text,
                                    'outer': outerEditingController.text,
                                    'top': topEditingController.text,
                                    'bottom': bottomEditingController.text,
                                    'shoes': shoesEditingController.text,
                                    'etc': etcEditingController.text,
                                  },
                                  onSuccess: (successData) async {
                                    FirebaseFirestore fireStore = FirebaseFirestore.instance;

                                    await fireStore
                                        .collection('chat_collection')
                                        .doc(info.chatRoomId)
                                        .update({'status': 'A'}).then((value) {
                                      Meet.alert(context, "알림", "수락되었습니다.").then((value1) {
                                        Navigator.pop(context);

                                        inviteList.removeAt(0);

                                        if (inviteList.isNotEmpty) {
                                          inviteModel(inviteList.first, context);
                                        }
                                      });
                                    });
                                  },
                                  onFail: (failData) {},
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
