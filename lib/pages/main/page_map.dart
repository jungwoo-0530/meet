import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';

import '../../common/api.dart';
import '../../common/common.dart';
import '../../common/constants.dart';
import '../../common/meet.dart';
import '../../common/routes.dart';
import '../../common/urls.dart';
import '../map/do.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _isLoading = true;

  late List<LocationDetail> locationList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _isLoading = true;
        setState(() {});
        locationList = [];

        apiGetLocationList().then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      },
      child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  // padding: EdgeInsets.all(Consts.marginPage),
                  padding: EdgeInsets.fromLTRB(0, Consts.marginPage, 0, Consts.marginPage),
                  child: ListView(
                    children: [
                      if (locationList.isEmpty) ...[
                        SizedBox(
                          height: 500.h,
                        ),
                        const Center(child: Text("등록된 위치가 없습니다.")),
                      ] else ...[
                        for (int i = 0; i < locationList.length; i++) ...[
                          item(locationList[i]),
                        ],
                      ],
                    ],
                  ),
                )),
    );
  }

  Widget item(LocationDetail location) {
    Widget status;

    bool isMyOwner = location.ownerId == Meet.user.loginId;

    switch (location.status) {
      case "W":
        status = const Text("대기중", style: TextStyle(color: Colors.red));
        break;
      case "A":
        status = const Text("거래중", style: TextStyle(color: Colors.blue));
        break;
      case "C":
        status = Text(isMyOwner ? "거절됨" : "거절함", style: const TextStyle(color: Colors.red));
        break;
      default:
        status = const Text("종료", style: TextStyle(color: Colors.grey));
    }

    return InkWell(
      onTap: () {
        if (location.status == "C") {
          // 취소된
          Meet.alert(context, "알림", "취소된 거래입니다.");
        } else if (location.status == "A") {
          // 거래중
          Navigator.pushNamed(context, ROUTES.MAP_DETAIL, arguments: {
            'locationId': location.locationId.toString(),
            'title': location.ownerId == Meet.user.loginId ? location.otherId : location.ownerId
          });
        } else if (location.status == "E") {
          // W : 종료
          Meet.alert(context, "알림", "종료된 거래입니다.");
          // Navigator.pushNamed(context, ROUTES.MAP_DETAIL, arguments: {'locationId': location.locationId.toString()});
        } else {
          // W : 대기중
          Meet.alert(context, "알림", "상대방의 수락이 필요합니다.");
        }
      },
      child: Container(
        height: 120.h,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(Consts.marginPage, 0, Consts.marginPage, 0),
        margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 16.h),
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              // side: BorderSide(width: 2.w, color: widget.borderColor),
              borderRadius: BorderRadius.circular(32.r),
            ),
            shadows: [
              BoxShadow(
                color: const Color(0x14000000),
                blurRadius: 32.r,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isMyOwner == true) ...[
                  Text(
                    location.otherId,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ] else ...[
                  Text(
                    location.ownerId,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.w, color: const Color(0xFFD2D2D2)),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    itemBuilder: (BuildContext context) {
                      List<PopupMenuEntry<int>> menuList = [];
                      menuList.add(PopupMenuItem(
                        value: 0,
                        padding: EdgeInsets.zero,
                        height: 75.h,
                        child: Center(
                          child: Text(
                            "삭제",
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ));

                      return menuList;
                    },
                    onSelected: (selected) {
                      meetlog(selected.toString());

                      switch (selected) {
                        /*case 0:
                          meetlog("수정");
                          break;*/
                        case 0:
                          meetlog("삭제");
                          apiDeleteLocation(location.locationId, location.chatRoomId);
                          break;
                      }
                    },
                    child: const Icon(Icons.more_vert)),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  location.destinationAddress,
                  style: TextStyle(
                    fontSize: 24.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                status,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> apiGetLocationList() async {
    await API.callGetApi(
      URLS.getMapList,
      parameters: {
        "id": Meet.user.loginId,
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          if (successData['count'] > 0) {
            List locationTempList = successData['data'];
            List<LocationDetail> generatedList = [];
            for (var element in locationTempList) {
              generatedList.add(LocationDetail.fromJson(element));
            }

            locationList.addAll(generatedList);
          }
        } else {}
      },
      onFail: (failData) {},
    );
  }

  Future<void> apiDeleteLocation(int locationId, String chatRoomId) async {
    Meet.alertYN(context, "알림", '삭제하시겠습니까?\n삭제할 경우 채팅 내역도 삭제됩니다.').then((value) async {
      if (value == true) {
        await API.callPostApi(
          URLS.deleteMap,
          parameters: {
            'locationId': locationId.toString(),
          },
          onSuccess: (successData) {
            if (successData['status'] == "200") {
              Meet.alert(context, "알림", successData['message']).then((value) {
                setState(() {
                  _isLoading = true;
                  locationList.clear();

                  // 대화방 상태 변경, 안 보이도록 설정
                  FirebaseFirestore.instance.collection('chat_collection').doc(chatRoomId).update({
                    'status': 'E',
                    'useYn': 'N',
                  }).then((value) {
                    apiGetLocationList().then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  });
                });
              });
            } else {}
          },
          onFail: (failData) {},
        );
      } else {
        return;
      }
    });
  }
}
