import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ya_meet/common/common.dart';

import '../common/constants.dart';
import '../common/meet.dart';
import '../common/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenRouteFunction(
        duration: 2500,
        splash: ScreenUtilInit(
            useInheritedMediaQuery: true,
            splitScreenMode: Meet.isFoldTypePhone ? false : false,
            designSize: Meet.isFoldTypePhone
                ? Size(Consts.designWidth, Consts.designHeight)
                : Size(Consts.designWidth, Consts.designHeight),
            minTextAdapt: true,
            builder: (BuildContext context, __) {
              return const Scaffold(
                  body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Hi"),
                  ],
                ),
              ));
            }),
        splashIconSize: double.infinity,
        backgroundColor: Colors.white,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        screenRouteFunction: () async {
          if (Meet.user.logined) {
            meetlog("로그인 상태");
            return ROUTES.MAIN;
          } else {
            meetlog("비로그인 상태");
            return ROUTES.LOGIN;
          }
        });
  }
}
