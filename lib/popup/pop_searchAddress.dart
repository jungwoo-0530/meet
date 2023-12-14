import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ya_meet/pages/map/do.dart';

import '../common/api.dart';
import '../common/common.dart';
import '../common/constants.dart';
import '../common/urls.dart';
import '../custom/sub_appbar.dart';

class SearchAddressPopup extends StatefulWidget {
  const SearchAddressPopup({super.key, required this.arguments});

  final Map<String, dynamic>? arguments;

  @override
  State<SearchAddressPopup> createState() => _SearchAddressPopupState();
}

class _SearchAddressPopupState extends State<SearchAddressPopup> {
  final TextEditingController addressEditingController = TextEditingController();

  List<Address> addressList = [];

  String address = "";
  String latitude = "";
  String longitude = "";

  // 실시간 검색을 위한 타이머
  Timer? _apiCallTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    addressEditingController.dispose();
    _apiCallTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MeetSubAppBar(
        title: "주소 검색",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Consts.marginPage, 15.h, Consts.marginPage, 15.h),
          child: Column(
            children: [
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
                  controller: addressEditingController,
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
                    hintText: "주소를 입력해 주세요.",
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
                      address = value;

                      _apiCallTimer?.cancel();
                      // 타이핑 1.5초 멈추면 API 호출.
                      _apiCallTimer = Timer(const Duration(milliseconds: 1500), () {
                        addressList.clear();
                        apiAddress();
                      });
                    });
                  },
                  onSubmitted: (value) {},
                ),
              ),
              if (address.isNotEmpty) ...[
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Map<String, dynamic> returnData = {
                            'address': addressList[index].roadAddress,
                            'NLatLng': NLatLng(
                                double.parse(addressList[index].latitude), double.parse(addressList[index].longitude)),
                          };
                          Navigator.pop(context, returnData);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100.h,
                              width: double.infinity,
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
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
                                child: Text(addressList[index].roadAddress),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Expanded(child: Center(child: Text("검색결과가 없습니다."))),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Future<void> apiAddress() async {
    await API.callNaverApi(
      URLS.naverGeoCoding,
      parameters: {'query': address},
      onSuccess: (successData) {
        if (successData['status'] == 'OK') {
          if (successData['meta']['count'] > 0) {
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
        setState(() {});
      },
    );
  }
}
