import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ya_meet/custom/meet_button.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

import '../../common/constants.dart';
import '../../common/routes.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final TextEditingController idEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController nicknameEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              MeetButton(
                title: "등록",
                onPressed: () {
                  // TODO: 회원가입 API 호출
                  // 성공시 홈으로 이동
                  // API에서 accessToken 받아옴.
                  Navigator.pushNamed(context, ROUTES.HOME);
                },
                radius: 32.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
