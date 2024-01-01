class URLS {
  /// 개발서버 서버 도메인
  static String get domain => "http://localhost:8080";

  static String get host => "https://$domain";

  /// API 호출 서버
  static String get apiHost => domain;
  static String get root => "$host/";

  // kakao
  static String get kakaoDomain => "https://dapi.kakao.com/v2";

  // kakao 주소 검색
  static String get kakaoSearchAddress => "/local/search/address.json";

  // kakao 키워드 주소 검색
  static String get kakaoSearchKeyword => "/local/search/keyword.json";

  // google
  static String get googleDomain => "https://maps.googleapis.com";

  static String get googleReverseGeoCoding => "/maps/api/geocode/json"; // 좌표 -> 주소

  // 네이버
  static String get naverDomain => "https://naveropenapi.apigw.ntruss.com";

  // 네이버 지오코딩
  static String get naverGeoCoding => "$naverDomain/map-geocode/v2/geocode"; // 주소 -> 좌표
  static String get naverReverseGeoCoding => "$naverDomain/map-reversegeocode/v2/gc"; // 좌표 -> 주소

  // 네이버 Direction15
  static String get naverDirection15 => "$naverDomain/map-direction-15/v1/driving";

  // 멤버
  static String get join => "/api/member/join";
  static String get login => "/api/member/login";
  static String get checkName => "/api/member/check/name";
  static String get getMemberInfo => "/api/member/info"; // 멤버 상세 조회\
  static String get updateMemberInfo => "/api/member/update"; // 멤버 정보 수정

  // 맵
  static String get addMap => "/api/map/add";
  static String get getMapDetail => "/api/map/detail";
  static String get getMapList => "/api/map/list";
  static String get deleteMap => "/api/map/delete";
  static String get getOtherLocation => "/api/map/location/other";
  static String get updateLocation => "/api/map/location/update";

  //초대
  static String get getInviteList => "/api/map/invite/list";
  static String get acceptInvite => "/api/map/accept";

  // 채팅
  static String get getChatList => "/api/chat/list";

  //인상착의
  static String get updateLook => "/api/look/update";
}
