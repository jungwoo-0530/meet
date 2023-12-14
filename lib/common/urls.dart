class URLS {
  /// 개발서버 서버 도메인
  static String get domain => "http://localhost:8080";

  static String get host => "https://$domain";

  /// API 호출 서버
  static String get apiHost => domain;
  static String get root => "$host/";

  // 네이버
  static String get naverDomain => "https://naveropenapi.apigw.ntruss.com";

  // 네이버 지오코딩
  static String get naverGeoCoding => "$naverDomain/map-geocode/v2/geocode"; // 주소 -> 좌표
  static String get naverReverseGeoCoding => "$naverDomain/map-reversegeocode/v2/gc"; // 좌표 -> 주소

  // 네이버 Direction15
  static String get naverDirection15 => "$naverDomain/map-direction-15/v1/driving";
}