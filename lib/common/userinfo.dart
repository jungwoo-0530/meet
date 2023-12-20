import 'package:shared_preferences/shared_preferences.dart';
import 'package:ya_meet/common/common.dart';

import 'constants.dart';
import 'meet.dart';

class UserInfo {
  bool _logined = false;

  String loginId = "";
  String nickName = "";
  String email = "";
  String telephone = "";
  int userSeq = -1;

  bool get logined => _logined && userSeq != -1;

  void init() {
    _logined = false;

    loginId = "";
    nickName = "";
    email = "";
    telephone = "";
    userSeq = -1;
  }

  Future<void> setLoginInfo({
    required bool isLogined,
    required String loginId,
    required String nickName,
    required String email,
    required String telephone,
    required int userSeq,
  }) async {
    _logined = isLogined;

    Meet.user.nickName = nickName;
    Meet.user.loginId = loginId;
    Meet.user.userSeq = userSeq;
    Meet.user.email = email;
    Meet.user.telephone = telephone;

    meetlog("로그인 정보 userSeq : $userSeq");
    saveLoginInfo();
  }

  void saveLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Consts.prefLogined, Meet.user._logined);
    await prefs.setString(Consts.prefNickname, Meet.user.nickName);
    await prefs.setString(Consts.prefLoginId, Meet.user.loginId);
    await prefs.setString(Consts.prefEmail, Meet.user.email);
    await prefs.setString(Consts.prefTelephone, Meet.user.telephone);
    await prefs.setInt(Consts.prefUserSeq, Meet.user.userSeq);
  }

  void loadLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Meet.user._logined = prefs.getBool(Consts.prefLogined) ?? false;
    Meet.user.nickName = prefs.getString(Consts.prefNickname) ?? "";
    Meet.user.loginId = prefs.getString(Consts.prefLoginId) ?? "";
    Meet.user.email = prefs.getString(Consts.prefEmail) ?? "";
    Meet.user.telephone = prefs.getString(Consts.prefTelephone) ?? "";
    Meet.user.userSeq = prefs.getInt(Consts.prefUserSeq) ?? -1;
    meetlog("사용자 정보 로드함 : $_logined / $nickName / $userSeq");
  }

  void setLogout() {
    meetlog("로그아웃 처리");
    Meet.user.init();
    saveLoginInfo();
  }
}
