import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("로그인", style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 90.h,
                    width: 400.w,
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
                        hintText: "아이디",
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
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 90.h,
                    width: 400.w,
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
                        hintText: "비밀번호",
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
              SizedBox(
                height: 20.h,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, ROUTES.MAIN, (route) => false);
                },
                child: Text("로그인"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ROUTES.JOIN);
                },
                child: Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
