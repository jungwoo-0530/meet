import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/common/routes.dart';
import 'package:ya_meet/common/urls.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'meet.dart';

class API {
  static bool showResponseLog = true;

  static String get HOST => URLS.apiHost;

  static String get NAVER_HOST => URLS.naverDomain;

  static String get GOOGLE_HOST => URLS.googleDomain;

  static String get KAKAO_HOST => URLS.kakaoDomain;

  static String get OK => "success";
  static String get ERROR => "error";

  static Future<void> callPostApi(String api,
      {Map<String, String>? parameters,
      List<MultipartFile>? files,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";

    meetlog('$api API Call : $parameters');
    Uri uri = Uri.parse('${URLS.domain}$api');
    try {
      var request = http.Request('POST', uri);
      request.headers.addAll({'User-Agent': 'MEET', 'Content-Type': 'application/json'});
      request.body = jsonEncode(parameters);
      // if (parameters != null) request.fields.addAll(parameters);
      // if (files != null) request.files.addAll(files);

      var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = await response.stream.bytesToString();
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

          onSuccess(json);
        }
      } else {
        meetlog('API $HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    }
  }

  static Future<void> callGetApi(String api,
      {Map<String, String>? parameters,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";

    meetlog('$api API Call : $parameters');
    // Uri uri = Uri.parse('${URLS.domain}$api');

    Uri uri = Uri.http('localhost:8080', api, parameters);

    meetlog(uri.toString());

    try {
      var request = http.Request('GET', uri);
      request.headers.addAll({'User-Agent': 'MEET', 'Content-Type': 'application/json'});
      request.body = jsonEncode(parameters);
      // if (parameters != null) request.fields.addAll(parameters);
      // if (files != null) request.files.addAll(files);

      var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = await response.stream.bytesToString();
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

          onSuccess(json);
        }
      } else {
        meetlog('API $HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    }
  }

  static Future<void> callWithAction(String api,
      {Map<String, String>? parameters,
        List<MultipartFile>? files,
        Function(Map<String, dynamic>)? onSuccess,
        Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";


    meetlog('$api API Call : $parameters');
    Uri uri = Uri.parse('${URLS.domain}$api');
    try {
      var request = http.MultipartRequest('POST', uri);
      // request.headers.addAll({'User-Agent': 'PETCARE'});
      if (parameters != null) request.fields.addAll(parameters);
      if (files != null) request.files.addAll(files);

      var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = await response.stream.bytesToString();
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

            onSuccess(json);
        }
      } else {
        meetlog('API $HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    } on TimeoutException {
      meetlog("$api API Response : $resultTimeOut");
      if (onFail != null) {
        onFail(jsonDecode(resultTimeOut) as Map<String, dynamic>);
      }
    } on Error catch (e) {
      meetlog('API Error: $e');
      if (onFail != null) {
        onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
      }
    }
  }

  static Future<void> callNaverApi(String api,
      {Map<String, String>? parameters,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";

    meetlog('$api API Call : $parameters');
    String queryParams = "";
    if (parameters != null) queryParams = "?${generateQueryString(parameters)}";
    Uri uri = Uri.parse('$api$queryParams');
    try {
      var request = http.Request('GET', uri);

      request.headers.addAll({
        'X-NCP-APIGW-API-KEY-ID': dotenv.env['naver_map_client_id']!,
        'X-NCP-APIGW-API-KEY': dotenv.env['naver_map_client_secret']!
      });

      var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = await response.stream.bytesToString();
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

          onSuccess(json);
        }
      } else {
        meetlog('API $NAVER_HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    }
  }

  static Future<void> callGoogleApi(String api,
      {Map<String, String>? parameters,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";

    meetlog('$api API Call : $parameters');
    String queryParams = "";
    if (parameters != null) {
      parameters["key"] = dotenv.env['google_map_key']!;
      parameters["language"] = "ko";
      queryParams = "?${generateQueryString(parameters)}";
    }
    Uri uri = Uri.parse('$GOOGLE_HOST$api$queryParams');
    try {
      var request = http.Request('GET', uri);

      var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = await response.stream.bytesToString();
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

          onSuccess(json);
        }
      } else {
        meetlog('API $GOOGLE_HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    }
  }

  static Future<void> callKaKaoApi(String api,
      {Map<String, String>? parameters,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";

    meetlog('$api API Call : $parameters');
    String queryParams = "";
    if (parameters != null) {
      queryParams = "?${generateQueryString(parameters)}";
    }
    Uri uri = Uri.parse('$KAKAO_HOST$api$queryParams');
    try {
      // var request = http.Request('GET', uri);

      var response = await http.get(uri, headers: {"Authorization": "KakaoAK 3b875900e9c2b3719e129d2bbe132e9f"});

      // var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = response.body;
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

          onSuccess(json);
        }
      } else {
        meetlog('API $KAKAO_HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    }
  }
}

String generateQueryString(Map<String, dynamic> params) {
  List queryString = [];
  params.forEach((key, value) {
    if (value != null) {
      queryString.add('$key=$value');
    }
  });
  return queryString.join('&');
}
