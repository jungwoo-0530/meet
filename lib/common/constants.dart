import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Consts {
  static double get designWidth => 720.0;
  static double get designHeight => 1560.0;
  static double get marginPage => 36.w;

  static double get tabbarLabelPadding => 2;
  static double get heightTabbar => 65;
  static double get widthTabbarIcon => 20;
  static double get heightTabbarIcon => 20;
  static double get fontSizeMainAppbarTitle => 38.sp;
  static double get fontSizeSubAppbarTitle => 32.sp;
  //static Color get primaryColor => const Color(0xff51C3A5); //기존 primaryColor
  static Color get primaryColor => const Color(0xff6B5AFF); //신규 primaryColor
  static Color get primaryOpacityColor => const Color(0xffE3E1FD).withOpacity(0.3); //신규 primaryColor
  static double get infinityScrollRatio => 0.7; //무한 스크롤 적용 시 API가 호출되는 기준

  static double get fontSizeTabbar => 12;
  static double get textLineHeight => 1.4;
  static TextHeightBehavior get textHeightBehavior => const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
        leadingDistribution: TextLeadingDistribution.even,
      );

  static String get prefPermissionsInfoConfirm => 'permissions_info_confirm';
  static String get prefAccessToken => 'access_token';
  static String get prefLogined => 'logined';
  static String get prefNickname => 'nickname';
  static String get prefProfileImage => 'profile_image';
  static String get prefUserSeq => 'user_seq';
}
