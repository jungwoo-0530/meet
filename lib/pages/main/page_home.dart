import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          : Center(
              child: Column(
                children: [
                  Container(
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
                  ),
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
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${info.inviterId}님이 서로의 위치 공유를 요청하셨습니다.",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
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
                              Navigator.pop(context);

                              inviteList.removeAt(0);

                              if (inviteList.isNotEmpty) {
                                inviteModel(inviteList.first, context);
                              }
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
                        onPressed: () {
                          // 수락

                          Navigator.pop(context);

                          inviteInfoModal(info, context);
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

  void inviteInfoModal(InviteInfo info, BuildContext context) {
    String address = "";
    LatLng? latLng;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter bottomState) {
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
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "초대를 수락하려면 다음 내용이 필요합니다.",
                        ),
                      ],
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

                          latLng = LatLng(position.latitude, position.longitude);

                          await API.callGoogleApi(URLS.googleReverseGeoCoding, parameters: {
                            // 'latlng': '${latLng?.latitude},${latLng?.longitude}',
                            'latlng': '37.2779594830596,127.03896078343',
                          }, onSuccess: (successData) {
                            String status = successData['status'];
                            if (status == 'OK') {
                              if (successData['results'].length > 0) {
                                String tempAddress = successData['results'][0]['formatted_address'];
                                address = tempAddress.replaceAll("대한민국 ", "");
                              }
                            } else if (status == "ZERO_RESULTS") {
                              Meet.alert(context, "알림", "주소를 찾을 수 없습니다.");
                            } else {
                              Meet.alert(context, "알림", "서버 에러");
                            }

                            bottomState(() {
                              setState(() {});
                            });
                          });
                        },
                        child: const Icon(Icons.location_searching),
                      ),
                    ],
                  ),
                  Text(address),
                  SizedBox(
                    height: 40.h,
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
                                'inviteeLongitude': "${latLng?.longitude}",
                                'inviteeAddress': address,
                                'inviteeId': Meet.user.loginId,
                                'status': "Y",
                              },
                              onSuccess: (successData) {
                                Navigator.pop(context);

                                inviteList.removeAt(0);

                                if (inviteList.isNotEmpty) {
                                  inviteModel(inviteList.first, context);
                                }
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
          );
        });
      },
    );
  }
}
