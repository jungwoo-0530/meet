import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ya_meet/common/urls.dart';
import 'package:ya_meet/common/userinfo.dart';

import '../main.dart';
import 'api.dart';
import 'common.dart';
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

  static final UserInfo user = UserInfo();

  static late Timer meetTimer;

  static double latitude = 0;
  static double longitude = 0;

  factory Meet() {
    return _instance;
  }

  static void init() {}

  /// 앱 실행을 위한 기본 작업들을 처리한다.
  static ready() {
    Meet.user.loadLoginInfo();
  }

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

  static Future<bool> permissionPhotosRequest() async {
    late PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        meetlog("안드로이드 12 이하");
        status = await Permission.storage.request();
      } else {
        meetlog("안드로이드 12 이상");
        status = await Permission.photos.request();
      }
    } else if (Platform.isIOS) {
      status = await Permission.photos.request();
    }

    switch (status) {
      case PermissionStatus.granted:
        meetlog("권한 있음");
        return true;
      case PermissionStatus.denied:
        meetlog("권한 없음");
        late PermissionStatus reStatus;
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt <= 32) {
            meetlog("안드로이드 12 이하");
            reStatus = await Permission.storage.request();
          } else {
            meetlog("안드로이드 12 이상");
            reStatus = await Permission.photos.request();
          }
        } else if (Platform.isIOS) {
          reStatus = await Permission.photos.request();
        }
        return reStatus.isGranted ? true : false;
      case PermissionStatus.permanentlyDenied:
        meetlog("권한 영구 거부됨");
        Meet.alertYN(Meet.navigatorKey.currentContext!, "권한 없음", "앱 설정에서 사진접근 권한을 허용하시겠습니까?").then((value) {
          if (value == true) {
            openAppSettings();
          }
        });
        return false;
      case PermissionStatus.restricted: //ios
        meetlog("권한 한정됨");
        return false;
      case PermissionStatus.limited: //ios
        meetlog("권한 제한됨");
        return true;
      default:
        meetlog("알려지지 않은 권한 상태");
        return false;
    }
  }

  static Future<bool> alertYN(BuildContext context, String title, String message, {String checkBtnTitle = "확인"}) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.r),
            ),
            //title: title.isNotEmpty ? Text(title, style: const TextStyle(fontSize: 18, color: Color(0xFF222222))) : null,
            content: Text(
              message,
              style: TextStyle(
                color: const Color(0xFF222222),
                fontSize: 28.sp,
                fontWeight: FontWeight.w400,
                height: Consts.textLineHeight,
              ),
            ),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  result = false;
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '취소',
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              //SizedBox(width: 60.w),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  result = true;
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(checkBtnTitle,
                    style: TextStyle(
                      color: const Color(0xFF222222),
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w400,
                    )),
              ),
            ],
          );
        });

    return result;
  }

  static Future<void> apiUpdateMyLocation() async {
    getCurrentLocation().then((value) async {
      await API.callPostApi(
        URLS.updateLocation,
        parameters: {
          'myLoginId': Meet.user.loginId,
          'ownerLatitude': latitude.toString(),
          'ownerLongitude': longitude.toString(),
        },
        onSuccess: (json) {
          meetlog(json.toString());
        },
      );
    });

  }

  static Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    // print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      meetlog(e.toString());
    }
  }

}
