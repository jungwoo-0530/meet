import 'package:shared_preferences/shared_preferences.dart';
import 'package:ya_meet/common/common.dart';

import 'constants.dart';
import 'meet.dart';

class UserInfo {
  bool _logined = false;

  String nickName = "";
  String accessToken = "";
  String profileImage = "";

  int userSeq = -1;

  void init() {
    _logined = false;

    nickName = "";
    accessToken = "";
    profileImage = "";

    userSeq = -1;
  }

  Future<void> setLoginInfo(
      {required bool isLogined,
      required String nickName,
      required String accessToken,
      required String email,
      required bool isDoctor,
      String userStats = "U",
      required int userSeq,
      required String snsGB,
      required String snsID,
      required String profileImage}) async {
    _logined = isLogined;

    Meet.user.nickName = nickName;
    Meet.user.profileImage = profileImage;
    Meet.user.accessToken = accessToken;

    Meet.user.userSeq = userSeq;

    meetlog("로그인 정보 accesstoken setting : $accessToken");
    meetlog("로그인 정보 accesstoken userStats : $userStats");
    saveLoginInfo();
  }

  void saveLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Consts.prefAccessToken, Meet.user.accessToken);
    await prefs.setBool(Consts.prefLogined, Meet.user._logined);
    await prefs.setString(Consts.prefNickname, Meet.user.nickName);
    await prefs.setString(Consts.prefProfileImage, Meet.user.profileImage);
    await prefs.setInt(Consts.prefUserSeq, Meet.user.userSeq);
  }

  void loadLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Meet.user.accessToken = prefs.getString(Consts.prefAccessToken) ?? "";
    Meet.user._logined = prefs.getBool(Consts.prefLogined) ?? false;
    Meet.user.nickName = prefs.getString(Consts.prefNickname) ?? "";
    Meet.user.profileImage = prefs.getString(Consts.prefProfileImage) ?? "";
    Meet.user.userSeq = prefs.getInt(Consts.prefUserSeq) ?? -1;
    meetlog("사용자 정보 로드함 : $_logined / $accessToken");
  }

  void setLogout() {
    meetlog("로그아웃 처리");
    Meet.user.init();
    saveLoginInfo();
  }
}
