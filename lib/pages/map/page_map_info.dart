import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:ya_meet/custom/sub_appbar.dart';
import 'package:ya_meet/pages/map/do.dart';

import '../../common/api.dart';
import '../../common/constants.dart';
import '../../common/meet.dart';
import '../../common/urls.dart';
import '../../custom/meet_button.dart';

class InfoMapPage extends StatefulWidget {
  const InfoMapPage({super.key, required this.arguments});

  final Map<String, dynamic>? arguments;

  @override
  State<InfoMapPage> createState() => _InfoMapPageState();
}

class _InfoMapPageState extends State<InfoMapPage> {
  bool _isLoading = true;

  LocationDetail? locationDetail;

  @override
  void initState() {
    apiGetMapDetail().then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: (){
      },
      child: Scaffold(
        appBar: MeetSubAppBar(
          title: '상세 페이지',
          actions: [
            _isLoading
                ? Container()
                : InkWell(
                    onTap: () {
                      modifyLook(context, locationDetail!);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: Consts.marginPage),
                      child: const Icon(
                        Icons.mode_edit,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.fromLTRB(Consts.marginPage, 10.h, Consts.marginPage, 10.h),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100.w,
                            child: Text(
                              "장소",
                              style: TextStyle(
                                fontSize: 30.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: locationDetail?.destinationAddress,
                                          style: TextStyle(
                                            fontSize: 30.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          "나의 인상 착의",
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "모자",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.myHat,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "아우터",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.myOuter,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "상의",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.myTop,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "하의",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.myBottom,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "신발",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.myShoes,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "기타",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.myEtc,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      ExpansionTile(
                        title: Text(
                          "상대방 인상 착의",
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "모자",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.otherHat,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "아우터",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.otherOuter,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "상의",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.otherTop,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "하의",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.otherBottom,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "신발",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.otherShoes,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  "기타",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: locationDetail?.otherEtc,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> apiGetMapDetail() async {
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
          });
        }
      },
    );
  }

  void modifyLook(BuildContext context, LocationDetail locationDetail) {
    final TextEditingController hatEditingController = TextEditingController();
    final TextEditingController outerEditingController = TextEditingController();
    final TextEditingController topEditingController = TextEditingController();
    final TextEditingController bottomEditingController = TextEditingController();
    final TextEditingController shoesEditingController = TextEditingController();
    final TextEditingController etcEditingController = TextEditingController();

    hatEditingController.text = locationDetail.myHat;
    outerEditingController.text = locationDetail.myOuter;
    topEditingController.text = locationDetail.myTop;
    bottomEditingController.text = locationDetail.myBottom;
    shoesEditingController.text = locationDetail.myShoes;
    etcEditingController.text = locationDetail.myEtc;

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
                spacing: 60.w,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "인상착의 수정",
                      style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  ExpansionTile(
                    title: Text(
                      "나의 인상 착의",
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
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
                            await API.callPostApi(
                              URLS.updateLook,
                              parameters: {
                                'id': locationDetail.myLookId.toString(),
                                'hat': hatEditingController.text,
                                'outer': outerEditingController.text,
                                'top': topEditingController.text,
                                'bottom': bottomEditingController.text,
                                'shoes': shoesEditingController.text,
                                'etc': etcEditingController.text,
                              },
                              onSuccess: (successData) {
                                Navigator.pop(context);
                              },
                              onFail: (failData) {
                                Meet.alert(context, "알림", failData['message']);
                              },
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
    ).whenComplete((){
      setState(() {
        _isLoading = true;
      });
      apiGetMapDetail().then((value){
        setState(() {
          _isLoading = false;
        });
      });
    });
  }
}
