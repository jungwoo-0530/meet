import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    locationList = [];

    apiGetLocationList().then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      Center(child: Text("등록된 위치가 없습니다.")),
                    ] else ...[
                      for (int i = 0; i < locationList.length; i++) ...[
                        item(locationList[i]),
                      ],
                    ],
                  ],
                ),
              ));
  }

  Widget item(LocationDetail location) {
    Widget status;

    bool isMyOwner = location.ownerId == Meet.user.loginId;

    switch (location.status) {
      case "W":
        status = Text("대기중", style: TextStyle(color: Colors.red));
        break;
      case "A":
        status = Text("거래중", style: TextStyle(color: Colors.blue));
        break;
      case "C":
        status = Text(isMyOwner ? "거절됨" : "거절함", style: TextStyle(color: Colors.red));
        break;
      default:
        status = Text("종료", style: TextStyle(color: Colors.grey));
    }

    return InkWell(
      onTap: () {
        if (location.status == "C") {
          // 취소된
          Meet.alert(context, "알림", "취소된 거래입니다.");
        } else if (location.status == "A") {
          Navigator.pushNamed(context, ROUTES.MAP_DETAIL, arguments: {'locationId': location.locationId});
        } else {
          // W : 대기중
          Navigator.pushNamed(context, ROUTES.MAP_DETAIL, arguments: {'locationId': location.locationId});
        }
      },
      child: Container(
        height: 120.h,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(Consts.marginPage, 0, Consts.marginPage, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
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
                  ),
                ] else ...[
                  Text(
                    location.ownerId,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                ],
                status,
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              location.destinationAddress,
              style: TextStyle(
                fontSize: 24.sp,
              ),
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
}
