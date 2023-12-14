import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/api.dart';
import '../../common/common.dart';
import '../../common/constants.dart';
import '../../common/urls.dart';
import '../map/do.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(Consts.marginPage),
      child: ListView(
        children: [
          for (int i = 0; i < 10; i++) ...[
            InkWell(
              onTap: () {
                API.callNaverApi(
                  URLS.naverGeoCoding,
                  parameters: {'query': '양평로21'},
                  onSuccess: (successData) {
                    if (successData['status'] == 'OK') {
                      if (successData['meta']['count'] > 0) {
                        List<Address> addressList = [];
                        for (int i = 0; i < successData['meta']['count']; i++) {
                          addressList.add(Address.fromJson(successData['addresses'][i]));
                        }
                        for (var element in addressList) {
                          meetlog(element.roadAddress);
                        }
                      } else {
                        meetlog("주소 검색 결과가 없습니다.");
                      }
                    }
                  },
                );

                // Navigator.pushNamed(context, ROUTES.MAP_DETAIL);
              },
              child: Container(
                height: 100.h,
                width: double.infinity,
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
                child: Center(
                  child: Text("$i번째 맵"),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            )
          ],
        ],
      ),
    ));
  }
}
