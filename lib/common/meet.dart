import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../main.dart';
import 'constants.dart';

class Meet {
  Meet._privateConstructor();

  static final Meet _instance = Meet._privateConstructor();

  static final mainScaffoldKey = GlobalKey<ScaffoldState>();
  static final mainStateKey = GlobalKey<AppMainState>();
  static final navigatorKey = GlobalKey<NavigatorState>();

  static String fcmToken = "";
  static bool isFoldTypePhone = false;
  static bool isDonePopAgree = false;
  static bool isDonePopEvent = false;
  static bool isDonePopUserBan = false;
  static bool isNotActiveFocusDetector = false; //FocusDetector 활성화 여부

  static AppLifecycleState appState = AppLifecycleState.resumed;

  static int tabbarSelectedIndex = 0;

  factory Meet() {
    return _instance;
  }

  static void init() {}

  /// 앱 실행을 위한 기본 작업들을 처리한다.
  static ready() {}

  static Future<bool> alert(BuildContext context, String title, String message) async {
    bool result = false;
//final VoidCallback onAction;

    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.r),
            ),
            //title: title.isNotEmpty ? Text(title, style: TextStyle(fontSize: 18, color: const Color(0xFF222222))) : null,
            content: Text(message,
                style: TextStyle(
                  color: const Color(0xFF222222),
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  height: Consts.textLineHeight,
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    result = true;
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: const Color(0xFF222222),
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ],
          );
        });

    return result;
  }

  static void toast(String message, {ToastGravity? gravity}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 32.sp,
    );
  }

  // 위치 서비스 권한
  static Future<Position> permissionLocationRequest() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
