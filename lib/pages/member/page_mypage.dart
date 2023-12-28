import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ya_meet/common/routes.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

import '../../common/common.dart';
import '../../common/meet.dart';

class MyPagePage extends StatefulWidget {
  const MyPagePage({super.key});

  @override
  State<MyPagePage> createState() => _MyPagePageState();
}

class _MyPagePageState extends State<MyPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MeetSubAppBar(
        title: '마이페이지',
        actions: [
          InkWell(
            onTap: () {
              Meet.user.setLogout();
              Navigator.pushNamed(context, ROUTES.LOGIN);
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "로그아웃",
                  style: TextStyle(fontSize: 30.sp, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Divider(color: const Color(0xFFE2E2E2), thickness: 3.w, height: 0),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ROUTES.PROFILE);
                    },
                    child: Container(
                      height: 100.h,
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "프로필",
                          style: TextStyle(
                            color: const Color(0xFF222222),
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(color: const Color(0xFFE2E2E2), thickness: 3.w, height: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
