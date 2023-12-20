import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Consts {
  static String get appTitle => "Meet";

  static double get designWidth => 720.0;
  static double get designHeight => 1560.0;
  static double get marginPage => 36.w;

  static double get tabbarLabelPadding => 2;
  static double get heightTabbar => 65;
  static double get widthTabbarIcon => 20;
  static double get heightTabbarIcon => 20;
  static double get fontSizeMainAppbarTitle => 38.sp;
  static double get fontSizeSubAppbarTitle => 32.sp;
  static Color get primaryColor => const Color(0xff228b22);
  static Color get primaryOpacityColor => const Color(0xff228b22).withOpacity(0.3);

  static double get fontSizeTabbar => 12;
  static double get textLineHeight => 1.4;
  static TextHeightBehavior get textHeightBehavior => const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
        leadingDistribution: TextLeadingDistribution.even,
      );

  static String get prefPermissionsInfoConfirm => 'permissions_info_confirm';
  static String get prefLogined => 'logined';
  static String get prefNickname => 'nickname';
  static String get prefLoginId => 'loginId';
  static String get prefEmail => 'email';
  static String get prefTelephone => 'telephone';
  static String get prefUserSeq => 'user_seq';

  // 각종 메시지
  static String get msgErrorNotConnect => "서버에 연결할 수 없습니다.";
  static String get msgErrorTimeout => "네트워크 속도가 너무 느립니다.";
  static String get msgErrorUnknown => "알 수 없는 오류가 발생했습니다.";
  static String get msgErrorNoInternet => "연결이 원활하지 않습니다.\\n네트워크 상태 확인 후 다시 시도해 주세요.";
  static String get msgErrorDefault => "오류가 발생했습니다.";

  // 타임아웃 시간
  static int get timeoutNetwork => 60;
}
