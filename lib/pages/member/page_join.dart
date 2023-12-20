import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/custom/meet_button.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

import '../../common/api.dart';
import '../../common/constants.dart';
import '../../common/meet.dart';
import '../../common/routes.dart';
import '../../common/urls.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final TextEditingController idEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController telephoneEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: MeetSubAppBar(
          title: "회원가입",
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Consts.marginPage),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        "아이디",
                        style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
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
                                  controller: idEditingController,
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
                                    hintText: "아이디를 입력해 주세요.",
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
                                    setState(() {});
                                  },
                                  onSubmitted: (value) {},
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: MeetButton(
                                onPressed: () {},
                                title: "중복확인",
                                height: 90.h,
                                width: double.infinity,
                                radius: 10.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "비밀번호",
                        style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
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
                          controller: passwordEditingController,
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
                            hintText: "비밀번호를 입력해 주세요.",
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
                            setState(() {});
                          },
                          onSubmitted: (value) {},
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "이름",
                        style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
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
                          controller: nameEditingController,
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
                            hintText: "이름을 입력해 주세요.",
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
                            setState(() {});
                          },
                          onSubmitted: (value) {},
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "이메일",
                        style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
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
                          controller: emailEditingController,
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
                            hintText: "이메일을 입력해 주세요.",
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
                            setState(() {});
                          },
                          onSubmitted: (value) {},
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "핸드폰",
                        style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
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
                          controller: telephoneEditingController,
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
                            hintText: "핸드폰을 입력해 주세요.",
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
                            setState(() {});
                          },
                          onSubmitted: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                MeetButton(
                  title: "등록",
                  onPressed: () {
                    API.callWithAction(URLS.join, parameters: {
                      "loginId": idEditingController.text,
                      "password": passwordEditingController.text,
                      "name": nameEditingController.text,
                      "email": emailEditingController.text,
                      "telephone": telephoneEditingController.text,
                    }, onSuccess: (successData) {
                      if (successData['status'] == "200") {
                        Meet.alert(context, '알림', successData['message']).then((value) {
                          if (value) {
                            Navigator.pushNamed(context, ROUTES.LOGIN);
                          }
                        });
                      }
                    }, onFail: (failData) {
                      meetlog(failData.toString());
                    });

                    meetlog(
                        "${idEditingController.text} / ${passwordEditingController.text} / ${nameEditingController.text} / ${emailEditingController.text} / ${telephoneEditingController.text}");

                    // Navigator.pushNamed(context, ROUTES.HOME);
                  },
                  radius: 32.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
