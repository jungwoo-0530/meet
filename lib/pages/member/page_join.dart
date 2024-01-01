import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController passwordCheckEditingController = TextEditingController();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController telephoneEditingController = TextEditingController();

  bool isIdCheck = false;

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
        appBar: const MeetSubAppBar(
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
                      SizedBox(
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
                                  maxLength: 10,
                                  style: TextStyle(
                                    color: const Color(0xff222222),
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w400,
                                    decorationThickness: 0,
                                  ),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: "아이디 *",
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
                                      isIdCheck = false;
                                    });
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
                                onPressed: () async {

                                  if(idEditingController.text.isEmpty){
                                    Meet.alert(context, "알림", "아이디를 입력해 주세요.");
                                    return;
                                  }

                                  await API.callPostApi(
                                    URLS.checkLoginId,
                                    parameters: {
                                      "loginId": idEditingController.text,
                                    },
                                    onSuccess: (successData) {
                                      if (successData['status'] == "200") {
                                        Meet.alert(context, '알림', successData['message']);
                                        setState(() {
                                          isIdCheck = true;
                                        });
                                      }else{
                                        Meet.alert(context, '알림', successData['message']);
                                      }
                                    },
                                    onFail: (failData) {
                                      Meet.alert(context, '알림', failData['message']);
                                    },
                                  );
                                },
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
                          obscureText: true,
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
                            hintText: "비밀번호 *",
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
                        height: 10.h,
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
                          controller: passwordCheckEditingController,
                          obscureText: true,
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
                            hintText: "비밀번호 확인 *",
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
                      /*SizedBox(
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
                      ),*/
                      /*SizedBox(
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
                      ),*/
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
                          keyboardType: TextInputType.number,
                          maxLength: 20,
                          style: TextStyle(
                            color: const Color(0xff222222),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                            decorationThickness: 0,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, //숫자만!
                            // NumberFormatter(), // 자동하이픈
                            LengthLimitingTextInputFormatter(11) //13자리만 입력받도록 하이픈 2개+숫자 11개
                          ],
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "핸드폰 *",
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

                    if(idEditingController.text.isEmpty){
                      Meet.alert(context, "알림", "아이디를 입력해 주세요.");
                      return;
                    }

                    if(!isIdCheck){
                      Meet.alert(context, "알림", "아이디 중복확인을 해주세요.");
                      return;
                    }

                    if(passwordEditingController.text.isEmpty){
                      Meet.alert(context, "알림", "비밀번호를 입력해 주세요.");
                      return;
                    }

                    if(passwordCheckEditingController.text.isEmpty){
                      Meet.alert(context, "알림", "비밀번호 확인을 입력해 주세요.");
                      return;
                    }

                    if(passwordEditingController.text != passwordCheckEditingController.text){
                      Meet.alert(context, "알림", "비밀번호가 일치하지 않습니다.");
                      return;
                    }

                    if(!isValidPhoneNumberFormat(telephoneEditingController.text)){
                      Meet.alert(context, "알림", "핸드폰 번호를 확인해 주세요.");
                      return;
                    }


                    API.callPostApi(URLS.join, parameters: {
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
                      }else{
                        Meet.alert(context, '알림', successData['message']);
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

  bool isValidPhoneNumberFormat(String phoneNumber) {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(phoneNumber);
  }
}
